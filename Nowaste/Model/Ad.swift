//
//  Item.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 19/10/2021.
//

//
//  Item.swift
//  Barter
//
//  Created by Gilles Sagot on 05/10/2021.
//


struct Ad {
    let addedByUser: String
    let dateField: Double
    let title: String
    let description: String
    let imageURL: String
    let likes: Int
    let id: String

    
    init?(snapshot: [String:Any]) {
        guard
            let addedByUser = snapshot["addedByUser"] as? String,
            let dateField = snapshot["dateField"] as? Double,
            let title = snapshot["title"] as? String,
            let imageURL = snapshot["imageURL"] as? String,
            let description = snapshot["description"] as? String,
            let likes = snapshot["likes"] as? Int,
            let id = snapshot["id"] as? String
        else {
            return nil
        }
        self.title = title
        self.imageURL = imageURL
        self.addedByUser = addedByUser
        self.dateField = dateField
        self.description = description
        self.likes = likes
        self.id = id

    }

}
