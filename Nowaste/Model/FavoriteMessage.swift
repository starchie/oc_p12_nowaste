//
//  FavoriteMessage.swift
//  Nowaste
//
//  Created by Gilles Sagot on 23/11/2021.
//

import Foundation
import CoreData

public class FavoriteMessage: NSManagedObject {
    
    static func returnUser (from ad:String)-> Bool{
        // Request Ingredient
    
        let filter = ad
        let predicate = NSPredicate(format: "ad.id = %@", filter)
        let requestMessage: NSFetchRequest<FavoriteMessage> = FavoriteMessage.fetchRequest()
    
        requestMessage.predicate = predicate
        guard let resultMessage = try? AppDelegate.viewContext.fetch(requestMessage) else {return false}
        if resultMessage.first == nil {
            return false
        }else{
            return resultMessage.first!.sent
        }
        
   
    }
    

}
