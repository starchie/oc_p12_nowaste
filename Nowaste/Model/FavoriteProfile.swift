//
//  FavoriteProfile.swift
//  Nowaste
//
//  Created by Gilles Sagot on 22/11/2021.
//

import Foundation
import CoreData


public class FavoriteProfile: NSManagedObject {
    
    static func returnUser (from ad:String)-> [Profile]{
        // Request Ingredient
    
        let filter = ad
        let predicate = NSPredicate(format: "ad.id = %@", filter)
        let requestProfile: NSFetchRequest<FavoriteProfile> = FavoriteProfile.fetchRequest()
    
        requestProfile.predicate = predicate
        guard let resultProfiles = try? AppDelegate.viewContext.fetch(requestProfile) else {return []}
        var resultAsProfile = [Profile]()
        for result in resultProfiles {
            let profile = Profile(snapshot: ["id":result.id as Any, "userName":result.userName as Any, "dateField":result.dateField as Any, "activeAds":Int(result.activeAds) as Any, "imageURL":result.imageURL as Any, "latitude":result.latitude as Any, "longitude": result.longitude as Any, "geohash": result.geohash as Any ])
            resultAsProfile.append(profile!)
        }
    
        return resultAsProfile
        
    }
    
    
    
}
