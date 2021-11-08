//
//  FirebaseService.swift
//  Barter
//
//  Created by Gilles Sagot on 10/10/2021.
//

import Foundation
import Firebase
import GeoFireUtils


class FirebaseService {
    static var shared = FirebaseService()
    
    private init(){}
    
    var db = Firestore.firestore()
    var storage = Storage.storage().reference()
    
    var currentUser : User? { return Auth.auth().currentUser}
    var profile : Profile!
    
    var ads = [Ad]()
    var profiles = [Profile]()
    
    var radiusInM:Double!
    var center: CLLocationCoordinate2D!
    
    var distances = [Double]()
    
    var listener: Firebase.ListenerRegistration!
    
    //MARK: - GEO HASH
    
    func locationToHash (location: CLLocationCoordinate2D){
        let hash = GFUtils.geoHash(forLocation: location)
        print (hash)
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
        let imageRef = storage.child(location)
        
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
        let imageRef = storage.child("\(image)")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024 * 1024) { data, error in
            if let error = error {
                completionHandler(false,error.localizedDescription,nil)
            } else {
                completionHandler(true,nil,data)
            }
        }
    }
    
    //MARK: - AUTHENTICATION
    
    // LOGIN
    func login(mail:String, pwd:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        Auth.auth().signIn(withEmail: mail, password: pwd) { (user, error) in
            guard let _ = user, error == nil else {
                completionHandler(false, error?.localizedDescription)
                return
            }
            completionHandler(true, nil)
        }
        
    }
    
    // LOGOUT
    func logout(completionHandler: @escaping ((Bool, String? ) -> Void)){
        do {
            try Auth.auth().signOut()
        } catch let error {
            completionHandler(false, error.localizedDescription)
            print("Auth sign out failed: \(error)")
        }
        completionHandler(true,nil)
    }
    
    // REGISTER
    func register(mail:String, pwd:String, completionHandler: @escaping ((Bool, String? ) -> Void)) {
        Auth.auth().createUser(withEmail: mail, password: pwd) { _, error in
            if error == nil {
                Auth.auth().signIn(withEmail: mail, password: pwd)
                completionHandler(true,nil)
            } else {
                print("Error in createUser: \(error?.localizedDescription ?? "")")
                completionHandler(false,error?.localizedDescription)
            }
        }
        
    }
    
    //MARK: - USER PROFILE
    
    // SAVE
    func saveProfile (userName:String, latitude:Double, longitude:Double, imageURL:String, activeAds: Int, completionHandler: @escaping ((Bool, String? ) -> Void)){

        db.collection("users").document("\(currentUser!.uid)").setData(["userName":userName, "latitude":latitude, "longitude":longitude, "imageURL":imageURL, "activeAds":activeAds]) { error in
                if error == nil {
                    completionHandler(true,nil)
                } else {
                    completionHandler(false,error?.localizedDescription)
                }
            
            }
        
    }
    
    // UPDATE
    func updateProfile (field:String, by value:Any, completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("users").document("\(currentUser!.uid)").updateData(["\(field)": value]) { error in
                if error == nil {
                    completionHandler(true,nil)
                } else {
                    completionHandler(false,error?.localizedDescription)
                }
                
            }
        
    }
    
    // GET ALL USERS
    func getProfiles(completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents")
                completionHandler(false, error.localizedDescription)
            } else {
                self.profiles.removeAll()
                for document in snapshot!.documents {
                    let newItem = Profile(snapshot: document.data())
                    self.profiles.append(newItem!)
                    
                }
                completionHandler(true, nil)
                
            }
        }
    }
    
    // GET ONE USER
    func querryProfile(filter:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        let selection:Query = db.collection("users").whereField("id", isEqualTo: filter)
        selection.getDocuments(completion: { (querySnapshot, err) in
                                
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(false, err.localizedDescription)
            } else {
                for document in querySnapshot!.documents {
                    let profile = Profile(snapshot: document.data())
                    self.profile = profile
                }
                completionHandler(true, nil)
            } })
    }
    
    // UPDATE PASSWORD
    func updatePassword(_ password:String, completionHandler: @escaping ((Bool, String?)-> Void)){
        currentUser?.updatePassword(to: password){  error in
            if let error = error {
                completionHandler(false,error.localizedDescription)
            } else {
                completionHandler(true,nil)
                
            }
            
        }
        
    }
    
    // UPDATE EMAIL
    func updateEmail(_ mail:String, completionHandler: @escaping ((Bool, String?)-> Void)){
        currentUser?.updateEmail(to: mail){  error in
            if let error = error {
                completionHandler(false,error.localizedDescription)
            } else {
                completionHandler(true,nil)
                
            }
            
        }
        
    }
    
    
    //MARK: - ADVERT
    
    // CREATE
    func setAd(id:NSUUID, title:String, description:String, imageURL:String, date:Double,likes:Int, completionHandler: @escaping ((Bool, String? ) -> Void)) {
        db.collection("ads")
            .document("\(id.uuidString)")
            .setData(["title": title,
                      "description": description,
                      "imageURL": imageURL,
                      "addedByUser": "\(currentUser!.uid)",
                      "dateField": date,
                      "likes": likes]) { error in
                if error == nil {
                    completionHandler(true,nil)
                } else {
                    completionHandler(false,error?.localizedDescription)
                }
                
            }
    }
    
    // GET ADS FROM A USER
    func querryAds(filter:String, completionHandler: @escaping ((Bool, String? ) -> Void)){
        let selection:Query = db.collection("ads").whereField("addedByUser", isEqualTo: filter)
        listener = selection.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(false, err.localizedDescription)
            } else {
                self.ads.removeAll()
                for document in querySnapshot!.documents {
                    let newAd = Ad(snapshot: document.data())
                    self.ads.append(newAd!)
                }
                completionHandler(true, nil)
            } }
    }
    
    func removeListener(){
        listener.remove()
    }

    // GET ALL ADS
    func getAds(completionHandler: @escaping ((Bool, String? ) -> Void)){
        
        db.collection("ads")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completionHandler(false, error.localizedDescription)
                } else {
                    self.ads.removeAll()
                    for document in querySnapshot!.documents {
                        //DispatchQueue.main.async {
                        let newItem = Ad(snapshot: document.data())
                        self.ads.append(newItem!)
                        //}
                    }
                    self.ads.reverse()
                    completionHandler(true, nil)
                }
            }
    }
    
    func updateAd (field:String,id:String, by value:Any, completionHandler: @escaping ((Bool, String? ) -> Void)){
        db.collection("ads").document("\(id)").updateData(["\(field)": value]) { error in
                if error == nil {
                    completionHandler(true,nil)
                } else {
                    completionHandler(false,error?.localizedDescription)
                }
                
            }
        
    }
    


}
