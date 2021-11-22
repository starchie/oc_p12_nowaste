//
//  Ad.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 19/10/2021.
//

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
