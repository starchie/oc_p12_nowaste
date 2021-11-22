//
//  Favorite.swift
//  Nowaste
//
//  Created by Gilles Sagot on 16/11/2021.

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
    
    static func saveAdToFavorite( userUID:String, id:String, title:String, description:String, imageURL:String, date:Double,likes:Int, profile: Profile)  {
  
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
        
        let profileTosave = FavoriteProfile(context: AppDelegate.viewContext)
        profileTosave.activeAds = Int16(profile.activeAds)
        profileTosave.dateField = profile.dateField
        profileTosave.geohash = profile.geohash
        profileTosave.id = profile.id
        profileTosave.imageURL = profile.imageURL
        profileTosave.latitude = profile.latitude
        profileTosave.longitude = profile.longitude
        profileTosave.userName = profile.userName
        profileTosave.ad = ad
        
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
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "FavoriteAd")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
        guard ((try? AppDelegate.viewContext.execute(deleteRequest)) != nil)else{return}
        
        fetchRequest = NSFetchRequest(entityName: "FavoriteProfile")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      
        guard ((try? AppDelegate.viewContext.execute(deleteRequest)) != nil)else{return}


    }
    
    
    
}
