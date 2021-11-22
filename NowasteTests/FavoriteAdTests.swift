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
