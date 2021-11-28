//
//  FirebaseService.swift
//  Nowaste
//
//  Created by Gilles Sagot on 10/10/2021.

/// Copyright (c) 2021 Starchie
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.




import Foundation
import Firebase
import GeoFireUtils


class FirebaseService {
    static var shared = FirebaseService()
    
    private init(){}
    
    var db = Firestore.firestore()
    var storage =  Storage.storage()
    
    var currentUser : User? { return Auth.auth().currentUser}
    var profile : Profile!
    
    var profiles = [Profile]()
    var ads = [Ad]()
    
    var radiusInM:Double!
    var center: CLLocationCoordinate2D!
    var distances = [Double]()
    
    var lastMessageTitle:String = ""
    
    //MARK: - GEO HASH
    
    func locationToHash (location: CLLocationCoordinate2D) -> String{
        let hash = GFUtils.geoHash(forLocation: location)
        return hash
    }
    
    func getGeoHash (center: CLLocationCoordinate2D, radiusInM: Double, completionHandler: @escaping ((Bool, String? ) -> Void) ) {
        self.profiles.removeAll()
        self.distances.removeAll()
        self.center = center
        self.radiusInM = radiusInM
        
        var count = 0
        
        let queryBounds = GFUtils.queryBounds(forLocation: self.center,
                                              withRadius: self.radiusInM)
        let queries = queryBounds.map { bound -> Query in
            return db.collection("users")
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
           
        }
     
        for query in queries {
            //query.getDocuments(completion: getDocumentsCompletion)
            query.getDocuments(completion: { (querySnapshot, err) in
                    
                                if let err = err {
                                    print("Error getting documents: \(err)")
                                    completionHandler(false, err.localizedDescription)
                                } else {
                                    self.getDocumentsCompletion(snapshot: querySnapshot, error: err)
                                    count += 1
                                    if count == queries.count {
                                        completionHandler(true, nil)
                                    }
                                    
                                    
                                } })
           
        }
        
        
    }
    
    // Collect all the query results together into a single list
    func getDocumentsCompletion( snapshot: QuerySnapshot?, error: Error?) -> () {
        guard let documents = snapshot?.documents else {
            print("Unable to fetch snapshot data. \(String(describing: error))")
            return
        }
        
        if error != nil {
            print("error")
            
        }else{
            
            for document in documents {
                let lat = document.data()["latitude"] as? Double ?? 0
                let lng = document.data()["longitude"] as? Double ?? 0
                let coordinates = CLLocation(latitude: lat, longitude: lng)
                let centerPoint = CLLocation(latitude: center.latitude, longitude: center.longitude)
                
                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: coordinates)
           
                if distance <= radiusInM {
                    profiles.append(Profile(snapshot:document.data())!)
                    distances.append(distance)
                }
                
            }
            
        }
        
        
    }
        

    //MARK: - IMAGE DATA STORAGE
    
    func saveImage(PNG: Data, location:String, completionHandler: @escaping ((Bool, String? ) -> Void)) {
        
        // Create a reference to the file you want to upload
        let imageRef = storage.reference().child(location)
        
        let uploadTask = imageRef.putData(PNG, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                print("Error: [\(error?.localizedDescription ?? "Error")]")
                completionHandler(false, error?.localizedDescription)
                return
            }
        }
        uploadTask.observe(.progress) { snapshot in
          // progress
          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            
            print("Percentage Uploaded: [\(percentComplete.rounded())] \n")
        }
        
        uploadTask.observe(.failure) { snapshot in
            print("UPLOAD FAILED")
            completionHandler(false, snapshot.description)
        }
        
        uploadTask.observe(.success) { snapshot in
            print("UPLOAD SUCCESSFULL")
            completionHandler(true, nil)
        }
    
    }
    
    func loadImage(_ image:String, completionHandler: @escaping ((Bool, String?, Data? ) -> Void)){
        let imageRef = storage.reference().child("\(image)")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024 * 1024) { data, error in
            if let error = error {
                completionHandler(false,error.localizedDescription,nil)
            } else {
                completionHandler(true,nil,data)
            }
        }
    }
    
    func deleteImage(_ image:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        let imageRef = storage.reference().child("\(image)")
        
        // Delete the file
        imageRef.delete { error in
            guard error == nil else {
                completionHandler(false,error?.localizedDescription)
                return
                
            }
            completionHandler(true,nil)
        }
    }
    
    
    //MARK: - AUTHENTICATION
    
    // LOGIN
    func login(mail:String, pwd:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        Auth.auth().signIn(withEmail: mail, password: pwd) { (result, error) in
            guard let _ = result, error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            completionHandler(true, nil)
        }
        
    }
    
    // LOGOUT
    /*
    func logout(completionHandler: @escaping ((Bool, String? ) -> Void)){
        do {
            try Auth.auth().signOut()
        } catch let error {
            completionHandler(false, error.localizedDescription)
            print("Auth sign out failed: \(error)")
        }
        completionHandler(true,nil)
    }
    */
    // REGISTER
    func register(mail:String, pwd:String, completionHandler: @escaping ((Bool, String? ) -> Void)) {
        Auth.auth().createUser(withEmail: mail, password: pwd) { (result, error) in
            guard let _ = result, error == nil else {
                completionHandler(false,error?.localizedDescription)
                return
                
            }
                completionHandler(true,nil)
        }
        
    }
    
    //MARK: - USER PROFILE
    
    // SAVE
    
    func saveProfile (documentName:String, userName:String,id:String, date:Double, latitude:Double, longitude:Double, imageURL:String, activeAds: Int, geohash: String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        
        db.collection("users").document("\(documentName)").setData(["userName":userName,"id":id, "dateField":date, "latitude":latitude, "longitude":longitude, "imageURL":imageURL, "activeAds":activeAds, "geohash":geohash]) { error in
            guard error == nil else {
                completionHandler(false,error?.localizedDescription)
                return
            }
            completionHandler(true,nil)
        }
        
    }
    
    // UPDATE
    
    func updateProfile (user:String, field:String, by value:Any, completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("users").document("\(user)").updateData(["\(field)": value]) { error in
            guard error == nil else {
                completionHandler(false,error?.localizedDescription)
                return
            }
            completionHandler(true,nil)
        }
        
    }
    
    // GET ONE USER
    func querryProfile(filter:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        let selection:Query = db.collection("users").whereField("id", isEqualTo: filter)
       
        selection.getDocuments(completion: { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            for document in querySnapshot.documents {
                let profile = Profile(snapshot: document.data())
                self.profile = profile

            }
            guard self.profile != nil else {
                completionHandler(false, error?.localizedDescription)
                return
                
            }
            completionHandler(true, nil)
        } )
    }
    
    
    //MARK: - ADVERT
    
    // CREATE AN AD
    func setAd(userUID:String, id:String, title:String, description:String, imageURL:String, date:Double,likes:Int, completionHandler: @escaping ((Bool, String? ) -> Void)) {
        db.collection("ads").document("\(id)").setData(["title": title, "description": description, "imageURL": imageURL, "addedByUser": "\(userUID)", "dateField": date, "likes": likes, "id":id]) { error in
            guard error == nil else {
                completionHandler(false,error?.localizedDescription)
                return
            }
           
            completionHandler(true,nil)
            
        }
    }
    
    // GET ADS FROM A CURRENT USER
    func querryAds(filter:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        let selection:Query = db.collection("ads").whereField("addedByUser", isEqualTo: filter)
        selection.getDocuments { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            self.ads.removeAll()
            for document in querySnapshot.documents {
                let newAd = Ad(snapshot: document.data())
                self.ads.append(newAd!)
            }
            completionHandler(true, nil)
        }
    }
    
    // GET ADS FROM ARRAY OF USERS
    func querryAllAds(filter:[String], completionHandler: @escaping ((Bool, String? ) -> Void)){

            let selection:Query = db.collection("ads").whereField("addedByUser", in: filter)
            selection.getDocuments { (querySnapshot, error) in
                guard let querySnapshot = querySnapshot, error == nil else {
                    completionHandler(false, error?.localizedDescription)
                    return
                }
                
                self.ads.removeAll()
                for document in querySnapshot.documents {
                    let newAd = Ad(snapshot: document.data())
                    self.ads.append(newAd!)
                }
                completionHandler(true, nil)
                
            }
        
    }
    
    func updateAd (ad:String, field:String, by value:Any, completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("ads").document("\(ad)").updateData(["\(field)": value]) { error in
            guard error == nil else {
                completionHandler(false,error?.localizedDescription)
                return
            }
            completionHandler(true,nil)
        }
        
    }
    
    // DELETE AD
    func deleteAd (id:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("ads").document(id).delete() { error in
            guard error == nil  else {
                completionHandler(false,error?.localizedDescription)
                return
            }
            completionHandler(true,nil)
            
        }
    }
    
    //MARK: - MESSAGE
    
    // JUST TO KNOW TITLE
    func initMessage (id:String ){
        let selection = db.collection("message").document("\(id)_message")
        selection.getDocument { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, error == nil else { return }
            guard querySnapshot.data()?.isEmpty == false else { return }
            let titleValue = querySnapshot.data()!["ad"] as! String
            self.lastMessageTitle = titleValue
            print ("message init says \(self.lastMessageTitle)")
        }
        
    }
    
    func watchMessage (id:String, completionHandler: @escaping ((Bool, String?, [String:Any]? ) -> Void)){
        let selection = db.collection("message").document("\(id)_message")
        selection.getDocument { (querySnapshot, error) in
            guard let querySnapshot = querySnapshot, error == nil else {
                completionHandler(false, error?.localizedDescription, nil)
                return
            }
            guard querySnapshot.data()?.isEmpty == false else {
                completionHandler(false, error?.localizedDescription, nil)
                return
            }
            if querySnapshot.data()!["ad"] as! String != self.lastMessageTitle {
                completionHandler(true, nil, querySnapshot.data() )
                self.lastMessageTitle = querySnapshot.data()!["ad"] as! String
            }else {
                completionHandler(false, nil, nil )
            }
            
        }
        
    }
    
    func sendMessage (to uid:String, senderName: String, for ad:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("message").document("\(uid)_message").setData(["to": uid, "senderName": senderName, "ad":ad]) { error in
            guard error == nil  else {
                completionHandler(false,error?.localizedDescription)
                return
            }
            completionHandler(true,nil)
        }
        
    }
    
    
    //MARK: - UTILS
    
    // RETURN DELTATIME FROM DOUBLE TO READABLE STRING
    func getDate(dt: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY - HH:mm"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    // GET ADS WHERE TITLE HAVE WORD SUBSTRING AND RETURN USERS UID
    func searchAdsByKeyWord(_ word:String, array:[Ad])->[String]{
        var adsUIDResult = [String]()
        
        for i in 0..<array.count {
            let objc = array[i].title
            let string = word
            if objc.range(of: string, options: .caseInsensitive) != nil {
                adsUIDResult.append(array[i].addedByUser)
               
            }
        }
        return adsUIDResult
    }
    
    // SELECT PROFILES FROM USERS UID LIST -> RETURN PROFILES AND DISTANCES
    func getProfilesfromUIDList(_ uids: [String], arrayProfiles:[Profile],arrayDistances:[Double], result: ([Profile], [Double] ) -> Void ){
        var profilesInRadius = [Profile]()
        var distanceForProfilesInRadius = [Double]()
        
        for  i in 0..<arrayProfiles.count {
            for uid in uids {
                if arrayProfiles[i].id == uid {
                    profilesInRadius.append(arrayProfiles[i])
                    distanceForProfilesInRadius.append(arrayDistances[i])
                }
            }
        }
        
        result(profilesInRadius, distanceForProfilesInRadius)
    }
    
    // SELECT ADS FROM A USER UID
    func searchAdsFromProfile (uid:String,array:[Ad])->[Ad] {
        var selectedAds = [Ad]()
            for ad in array {
                if uid == ad.addedByUser {
                    selectedAds.append(ad)
                }
        }
        return selectedAds
    }
    
    // DONT NEED PROFILES THAT SHARE ANYTHING
    func removeProfileIfNoAd(_ profiles:[Profile], distances:[Double], result: ([Profile], [Double] ) -> Void ) {
        var resultProfiles = [Profile]()
        var resultDistances = [Double]()
       
        for i in 0..<profiles.count {
            if profiles[i].activeAds > 0 {
                print("profiles : \(profiles.count)")
                
                resultProfiles.append(profiles[i])
                resultDistances.append(distances[i])
            }
        }
        result(resultProfiles,resultDistances) 
    }


}
