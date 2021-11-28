//
//  Profile.swift
//  Nowaste
//
//  Created by Gilles Sagot on 05/10/2021.

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
