//
//  FavoriteAdTests.swift
//  NowasteTests
//
//  Created by Gilles Sagot on 17/11/2021.
//

import XCTest

@testable import Nowaste
import CoreData

class FavoriteAdTests: XCTestCase {

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
    
    func testFavoriteRecipeShouldReturnOneEntityWhenAddOneEntity() {
        //Given
        AppDelegate.container = ContainerManager(.inMemory).persistentContainer
        FavoriteAd.deleteAllCoreDataItems()
        //When
        
        // Add One entity
        FavoriteAd.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0)
        //Then
        XCTAssert(FavoriteAd.all.count == 1)
        XCTAssert(FavoriteAd.all[0].title == "carottes")
       
    }
 
    
    func testFavoriteRecipeShouldDeleteEntityWhenDeleteEntity() {
        //Given
        AppDelegate.container = ContainerManager(.inMemory).persistentContainer
        FavoriteAd.deleteAllCoreDataItems()
        // With One entity
        FavoriteAd.saveAdToFavorite(userUID: "1234", id: "12345678", title: "carottes", description: "donne des carottes", imageURL: "https://image.com", date: 1, likes: 0)
        
        //When
        FavoriteAd.deleteAd(id: "12345678")
        //Then
        XCTAssert(FavoriteAd.all.count == 0)
       
    }


}
