//
//  Item.swift
//  Barter
//
//  Created by Gilles Sagot on 05/10/2021.
//


struct Profile {
    let id: String
    let userName: String
    let dateField: Double
    let activeAds: Int
    let imageURL: String
    let latitude: Double
    let longitude: Double
    let geohash: String
    
    init?(snapshot: [String:Any]) {
        guard
            let id = snapshot["id"] as? String,
            let userName = snapshot["userName"] as? String,
            let dateField = snapshot["dateField"] as? Double,
            let activeAds = snapshot["activeAds"] as? Int,
            let imageURL = snapshot["imageURL"] as? String,
            let latitude = snapshot["latitude"] as? Double,
            let longitude = snapshot["longitude"] as? Double,
            let geohash = snapshot["geohash"] as? String
        else {
            return nil
        }
        self.id = id
        self.userName = userName
        self.dateField = dateField
        self.activeAds = activeAds
        self.imageURL = imageURL
        self.latitude = latitude
        self.longitude = longitude
        self.geohash = geohash
    }

}





/*
struct Item {
  let ref: DatabaseReference?
  let key: String
  let name: String
  let addedByUser: String
  var completed: Bool

  // MARK: Initialize with Raw Data
  init(name: String, addedByUser: String, completed: Bool, key: String = "") {
    self.ref = nil
    self.key = key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
  }

  // MARK: Initialize with Firebase DataSnapshot
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let addedByUser = value["addedByUser"] as? String,
      let completed = value["completed"] as? Bool
    else {
      return nil
    }
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.addedByUser = addedByUser
    self.completed = completed
  }

  // MARK: Convert Item to AnyObject
  func toAnyObject() -> Any {
    return [
      "name": name,
      "addedByUser": addedByUser,
      "completed": completed
    ]
  }
}
 */
