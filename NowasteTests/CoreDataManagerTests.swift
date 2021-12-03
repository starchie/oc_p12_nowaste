//
//  FavoriteAdTests.swift
//  NowasteTests
//
//  Created by Gilles Sagot on 17/11/2021.

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


import XCTest

@testable import Nowaste
import CoreData

class CoreDataManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCoreDataManagerShouldReturnOneEntityWhenAddOneEntity() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "1234", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
         
        //When

        // Add One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        //Then
        XCTAssert(CoreDataManager.shared.all.count == 1)
        XCTAssert(CoreDataManager.shared.all[0].title == "carottes")
       
    }
 

    func testCoreDataManagerShouldDeleteEntityWhenDeleteEntity() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "1234", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        
        //When
        CoreDataManager.shared.deleteAd(id: "12345678")
        //Then
        XCTAssert(CoreDataManager.shared.all.count == 0)
       
    }
    
    func testCoreDataManagerShouldDeleteAllEntityWhenDeleteEntity() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "1234", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        
        //When
        CoreDataManager.shared.deleteAllCoreDataItems()
        //Then
        XCTAssert(CoreDataManager.shared.all.count == 0)
        XCTAssert(CoreDataManager.shared.returnProfile(from: "12345678").isEmpty )
        XCTAssert(CoreDataManager.shared.returnMessage(from: "12345678") == false )
       
    }
    
    func testCoreDataManagerShouldFindEntityWhenEntityAlreadyExist() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "1234", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        
        //When
        let value = CoreDataManager.shared.findAd(id: "12345678")
        //Then
        XCTAssert(value == true)
       
    }
    
    func testCoreDataManagerShouldNotFindEntityWhenEntityNotExist() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "1234", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        
        //When
        let value = CoreDataManager.shared.findAd(id: "87654321")
        //Then
        XCTAssert(value == false)
       
    }
    
    func testCoreDataManagerShouldReturnProfileWhenSearchByAdID() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "Richard", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        
        //When
        let value = CoreDataManager.shared.returnProfile(from: "12345678").first
        //Then
        XCTAssert(value?.userName == "Richard")
       
    }
    
    func testCoreDataManagerShouldReturnMessageTrueWhenSearchByAdID() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "Richard", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: true)
        
        //When
        let value = CoreDataManager.shared.returnMessage(from: "12345678")
        //Then
        XCTAssert(value == true)
       
    }
    
    func testCoreDataManagerShouldReturnMessageFalseWhenSearchByAdID() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "Richard", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: false)
        
        //When
        let value = CoreDataManager.shared.returnMessage(from: "12345678")
        //Then
        XCTAssert(value == false)
       
    }
    
    func testCoreDataManagerGivenFavoritesWhenAlreadySavedThenShouldReturnTrue() {
        //Given
        CoreDataManager.shared.container = ContainerManager(.inMemory).persistentContainer
        CoreDataManager.shared.deleteAllCoreDataItems()
        
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "Richard", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        // With One entity
        CoreDataManager.shared.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0, profile: userProfile!, contact: true)
        
        //When
        let value = CoreDataManager.shared.findAd(id: "12345678")
        //Then
        XCTAssert(value == true)
       
    }


}
