//
//  Favorite.swift
//  Nowaste
//
//  Created by Gilles Sagot on 16/11/2021.
//

import Foundation
import CoreData
import SwiftUI

public class FavoriteAd: NSManagedObject {
    
    static var all: [Ad] {
        let requestFavorite: NSFetchRequest<FavoriteAd> = FavoriteAd.fetchRequest()
        guard let resultFavorite = try? AppDelegate.viewContext.fetch(requestFavorite) else {return []}
        var resultAsAd = [Ad]()
        for result in resultFavorite {
            let ad = Ad(snapshot: ["addedByUser":result.addedByUser as Any, "dateField":result.dateField as Any, "title":result.title as Any, "imageURL":result.imageURL as Any, "description":result.adDescription as Any, "likes":Int(result.likes) as Any, "id": result.id as Any])
            resultAsAd.append(ad!)
        }
    
        return resultAsAd
    }
    
    //MARK: - ADD AD TO FAVORITE
    
    static func saveAdToFavorite( userUID:String, id:String, title:String, description:String, imageURL:String, date:Double,likes:Int)  {
  
        let ad = FavoriteAd(context: AppDelegate.viewContext)
       
        ad.id = id
        ad.likes = Int16(likes)
        ad.imageURL = imageURL
        ad.title = title
        ad.dateField = date
        ad.adDescription = description
        ad.addedByUser = userUID
        
        // Save context
        guard ((try? AppDelegate.viewContext.save()) != nil) else {return}
        
    }
    
    static func deleteAd (id:String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteAd")
        let filter = id
        let predicate = NSPredicate(format: "id = %@", filter)
        fetchRequest.predicate = predicate

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        guard ((try? AppDelegate.viewContext.execute(deleteRequest)) != nil) else {return}
    
    }
    
    static func findAd (id:String)->Bool {
        for favorite in all {
            if favorite.id == id {
                return true
            }
        }
        return false
    }
    
    //MARK: - DELETE ALL ADS
    
    static func deleteAllCoreDataItems () {
        
        //To delete things in core data...
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteAd")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
        guard ((try? AppDelegate.viewContext.execute(deleteRequest)) != nil)else{return}


    }
    
    
    
}
