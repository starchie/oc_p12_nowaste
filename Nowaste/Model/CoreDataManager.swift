//
//  CoreDataManager.swift
//  Nowaste
//
//  Created by Gilles Sagot on 23/11/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    var container = ContainerManager().persistentContainer
    
    private var viewContext: NSManagedObjectContext {
        return container!.viewContext
    }

    //MARK: - ALL ADS
    
    var all: [Ad] {
        let requestFavorite: NSFetchRequest<FavoriteAd> = FavoriteAd.fetchRequest()
        guard let resultFavorite = try? viewContext.fetch(requestFavorite) else {return []}
        var resultAsAd = [Ad]()
        for result in resultFavorite {
            let ad = Ad(snapshot: ["addedByUser":result.addedByUser as Any, "dateField":result.dateField as Any, "title":result.title as Any, "imageURL":result.imageURL as Any, "description":result.adDescription as Any, "likes":Int(result.likes) as Any, "id": result.id as Any])
            resultAsAd.append(ad!)
        }
    
        return resultAsAd
    }
    
    //MARK: - ADD AD TO FAVORITE
    
    func saveAdToFavorite( userUID:String, id:String, title:String, description:String, imageURL:String, date:Double,likes:Int, profile: Profile, contact: Bool)  {
  
        let ad = FavoriteAd(context: CoreDataManager.shared.viewContext)
       
        ad.id = id
        ad.likes = Int16(likes)
        ad.imageURL = imageURL
        ad.title = title
        ad.dateField = date
        ad.adDescription = description
        ad.addedByUser = userUID
        
        // Save context
        guard ((try? CoreDataManager.shared.viewContext.save()) != nil) else {return}
        
        let profileTosave = FavoriteProfile(context: CoreDataManager.shared.viewContext)
        profileTosave.activeAds = Int16(profile.activeAds)
        profileTosave.dateField = profile.dateField
        profileTosave.geohash = profile.geohash
        profileTosave.id = profile.id
        profileTosave.imageURL = profile.imageURL
        profileTosave.latitude = profile.latitude
        profileTosave.longitude = profile.longitude
        profileTosave.userName = profile.userName
        profileTosave.ad = ad
        
        guard ((try? CoreDataManager.shared.viewContext.save()) != nil) else {return}
        
        let message = FavoriteMessage(context: CoreDataManager.shared.viewContext)
        message.sent = contact
        message.ad = ad
        
        guard ((try? CoreDataManager.shared.viewContext.save()) != nil) else {return}

    }
    
    //MARK: - DELETE AD
    
    func deleteAd (id:String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteAd")
        let filter = id
        let predicate = NSPredicate(format: "id = %@", filter)
        fetchRequest.predicate = predicate

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        guard ((try? CoreDataManager.shared.viewContext.execute(deleteRequest)) != nil) else {return}
    
    }
    
    //MARK: - FIND AD
    
    func findAd (id:String)->Bool {
        for favorite in CoreDataManager.shared.all {
            if favorite.id == id {
                return true
            }
        }
        return false
    }
    
    //MARK: - DELETE ALL ADS
    
    func deleteAllCoreDataItems () {
        
        //To delete things in core data...
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteAd")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
        guard ((try? CoreDataManager.shared.viewContext.execute(deleteRequest)) != nil)else{return}
        
        fetchRequest = NSFetchRequest(entityName: "FavoriteProfile")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
        guard ((try? CoreDataManager.shared.viewContext.execute(deleteRequest)) != nil)else{return}
        
        fetchRequest = NSFetchRequest(entityName: "FavoriteMessage")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
        guard ((try? CoreDataManager.shared.viewContext.execute(deleteRequest)) != nil)else{return}


    }
    
    //MARK: - GET PROFILE
    
    func returnProfile (from ad:String)-> [Profile]{
        // Request Ingredient
    
        let filter = ad
        let predicate = NSPredicate(format: "ad.id = %@", filter)
        let requestProfile: NSFetchRequest<FavoriteProfile> = FavoriteProfile.fetchRequest()
    
        requestProfile.predicate = predicate
        guard let resultProfiles = try? CoreDataManager.shared.viewContext.fetch(requestProfile) else {return []}
        var resultAsProfile = [Profile]()
        for result in resultProfiles {
            let profile = Profile(snapshot: ["id":result.id as Any, "userName":result.userName as Any, "dateField":result.dateField as Any, "activeAds":Int(result.activeAds) as Any, "imageURL":result.imageURL as Any, "latitude":result.latitude as Any, "longitude": result.longitude as Any, "geohash": result.geohash as Any ])
            resultAsProfile.append(profile!)
        }
    
        return resultAsProfile
        
    }
    
    //MARK: - GET MESSAGE
    
    func returnMessage (from ad:String)-> Bool{
        // Request Ingredient
    
        let filter = ad
        let predicate = NSPredicate(format: "ad.id = %@", filter)
        let requestMessage: NSFetchRequest<FavoriteMessage> = FavoriteMessage.fetchRequest()
    
        requestMessage.predicate = predicate
        guard let resultMessage = try? CoreDataManager.shared.viewContext.fetch(requestMessage) else {return false}
        if resultMessage.first == nil {
            return false
        }else{
            return resultMessage.first!.sent
        }
        
   
    }
    
    
    
   
    
    
    
    
}
