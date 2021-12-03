//
//  FirebaseServiceTests.swift
//  FirebaseServiceTests
//
//  Created by Gilles Sagot on 08/11/2021.

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
import CoreLocation
import Firebase

class FirebaseServiceTests: XCTestCase {

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
    
    func testGivenDateWhenQuerryAsStringThenShouldReturnString () {
        //Given
        let date = 1637936047.251909
        //When
        let dateAsString = FirebaseService.shared.getDate(dt: date)
        // then
        XCTAssert(dateAsString == "26 11 2021 - 15:14")
        
    }
    
    
    func testGivenAdArrayWhenSearchByNameTitleThenShouldSuccess () {
        //Given
        let snapshots: [String:Any] = ["addedByUser":"User","dateField":1637936047.251909 , "title": "Carottes", "imageURL":"https://openclassrooms.com" , "description":"plein de carottes" , "likes":1 , "id":"1234"]
        let newAd = Ad(snapshot: snapshots)
        let ads = [newAd!]
        //When
       
        let result = FirebaseService.shared.searchAdsByKeyWord("caro", array: ads)
        
        
        // then
        XCTAssert(result.count == 1)
    }
    
    func testGivenProfilesArrayWhenSearchWithMultipleIDProfilesArrayThenShouldSuccess () {
        //Given
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "Richard", "dateField": 123.5, "activeAds": 1, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        let profiles = [userProfile!]
        let distances = [220.0]
        let uids = ["1234"]
        //When
        FirebaseService.shared.getProfilesfromUIDList(uids, arrayProfiles: profiles, arrayDistances: distances) { resultProfiles, resultDistances in
        //then
            XCTAssertTrue(resultProfiles.count == 1)
            XCTAssertTrue(resultProfiles.count == 1)
        }
        
    }
    
    
    func testGivenAdsArrayWhenSearchByIDProfileThenShouldSuccess () {
        //Given
        let snapshots: [String:Any] = ["addedByUser":"User234","dateField":1637936047.251909 , "title": "Carottes", "imageURL":"https://openclassrooms.com" , "description":"plein de carottes" , "likes":1 , "id":"1234"]
        let newAd = Ad(snapshot: snapshots)
        let ads = [newAd!]
        //When
        let selectedAdResult = FirebaseService.shared.searchAdsFromProfile(uid: "User234", array: ads)
        //then
            XCTAssertTrue(selectedAdResult.count == 1)
          
        }
    
    func testGivenProfilesArrayWhenProfileWithNoAdsThenShouldBeIgnored() {
        
        //Given
        let userProfile = Profile(snapshot: ["id": "1234", "userName": "Richard", "dateField": 123.5, "activeAds": 0, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        let profiles = [userProfile!]
        let distances = [220.0]
        
        // When
        FirebaseService.shared.removeProfileIfNoAd(profiles, distances: distances) {resultProfiles, resultDistances in
            //then
                XCTAssertTrue(resultProfiles.count == 0)
                XCTAssertTrue(resultDistances.count == 0)
            
        }
        
        
    }
    
    func testWhenSearchAWordThenItShouldReturnProfileWhoHasTheSearch () {
        //Given
        let snapshots: [String:Any] = ["addedByUser":"User234","dateField":1637936047.251909 , "title": "Carottes", "imageURL":"https://openclassrooms.com" , "description":"plein de carottes" , "likes":1 , "id":"1234"]
        let newAd = Ad(snapshot: snapshots)
        FirebaseService.shared.ads = [newAd!]
        let userProfile = Profile(snapshot: ["id": "User234", "userName": "Richard", "dateField": 123.5, "activeAds": 0, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        FirebaseService.shared.profiles = [userProfile!]
        FirebaseService.shared.distances = [220.0]
        
        //When
        FirebaseService.shared.returnProfileWithAdThatContainsTheWord("car") {
            success, resultProfiles, resultDistances in
            
            //then
                XCTAssertTrue(resultProfiles.count == 1)
        }
  
    }
    
    func testWhenSearchAWordThenItShouldReturnFalse () {
        //Given
        let snapshots: [String:Any] = ["addedByUser":"User234","dateField":1637936047.251909 , "title": "Carottes", "imageURL":"https://openclassrooms.com" , "description":"plein de carottes" , "likes":1 , "id":"1234"]
        let newAd = Ad(snapshot: snapshots)
        FirebaseService.shared.ads = [newAd!]
        let userProfile = Profile(snapshot: ["id": "User234", "userName": "Richard", "dateField": 123.5, "activeAds": 0, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        FirebaseService.shared.profiles = [userProfile!]
        FirebaseService.shared.distances = [220.0]
        
        //When
        FirebaseService.shared.returnProfileWithAdThatContainsTheWord("pomm") {
            success, resultProfiles, resultDistances in
            
            //then
                XCTAssertFalse(success)
        }
  
    }
    
    func testWhenSearchNothingThenItShouldReturnAll () {
        //Given
        let snapshots: [String:Any] = ["addedByUser":"User234","dateField":1637936047.251909 , "title": "Carottes", "imageURL":"https://openclassrooms.com" , "description":"plein de carottes" , "likes":1 , "id":"1234"]
        let newAd = Ad(snapshot: snapshots)
        FirebaseService.shared.ads = [newAd!]
        let userProfile = Profile(snapshot: ["id": "User234", "userName": "Richard", "dateField": 123.5, "activeAds": 0, "imageURL":"https://image.com","latitude": 12.4, "longitude": 12.4, "geohash":"ff4CC33" ])
        FirebaseService.shared.profiles = [userProfile!]
        FirebaseService.shared.distances = [220.0]
        
        //When
        FirebaseService.shared.returnProfileWithAdThatContainsTheWord("") {
            success, resultProfiles, resultDistances in
            
            //then
                XCTAssertTrue(success)
        }
  
    }
    
    /*
    ///// FIREBASE TESTS
    */
    
    
    // TESTS FIREBASE : NEED LOCAL FIREBASE EMULATOR
    // RULES FOR STORAGE AND FIRESTORE SET FOR TESTS :
    // allow read, write: if request.time < timestamp.date(2021, 12, 10); // Date of your choice
    
   
    // TEST AUTHENTICATION
    // REGISTER
    func test_A0_AuthWhenRegisterThenShouldSuccess() throws {
       // given
        let mail = "test@nowaste.com"
        let password = "123456"
        
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.register(mail: mail, pwd: password, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
     
    
    // SIGN IN
    func test_A1_AuthWhenSignInThenShouldSuccess() throws {
       // given
        let mail = "test@nowaste.com"
        let password = "123456"
        
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.login(mail: mail, pwd: password, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
    
    func test_A2_AuthWhenSignInWithBadPasswordThenShouldFail() throws {
       // given
        let mail = "test@nowaste.com"
        let password = "123455"
        
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.login(mail: mail, pwd: password, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertFalse(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
    
    // PROFILE
    
    func test_F1_FirestoreWhenRegisterThenShouldSetProfil() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        FirebaseService.shared.saveProfile(documentName: userUID, userName: "lulu",id : userUID, date:Date().timeIntervalSince1970, latitude: 2.23, longitude: 40.3445, imageURL: "blabla.com", activeAds: 0, geohash: "defffbbj", completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
    
    func test_F2_FirestoreWhenUpdateProfilThenShouldReturnSuccess() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        FirebaseService.shared.updateProfile(user:userUID, field: "userName", by: "Gillou", completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
    
    func test_F2_FirestoreWhenQuerryProfilThenShouldReturnSuccess() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        FirebaseService.shared.querryProfile(filter: userUID, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
    

     
    // ADS
    
    func test_F3_FirestoreWhenSetAdThenShouldSuccess() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        let adUID = "AdIdCreatedByApp"
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.setAd(userUID: userUID, id: adUID, title: "title", description: "description", imageURL: "http:imageurl", date: 12345.567, likes: 10, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
    }
    
    
    // TODO HERE ...
    func test_F4_FirestoreWhenQuerryAnAdThenShouldSucess() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.querryAds(filter: userUID, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }
   
    func test_F5_FirestoreWhenUpdateAnAdThenShouldSucess() throws {
       // given
        let adUID = "AdIdCreatedByApp"
        let value = FieldValue.increment(Int64(1))
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.updateAd(ad:adUID , field: "likes", by: value, completionHandler: { (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
  
    }

    
    func test_F6_GivenLocationWhenConvertToHashThenShouldReturnString() throws {
       // given
        let location = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
    
        
        // when
        let geoHash = FirebaseService.shared.locationToHash(location: location)
            
        // Then
        XCTAssert(geoHash == "u09v9q55p2")
           
    }
    
    func test_F7_GivenLocationWhenConvertToHashThenShouldReturnString() throws {
       // given
        let location = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
    
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.getGeoHash(center: location, radiusInM: 5000, completionHandler: { (success, error) in
            
            // Then
                XCTAssertTrue(success)
                expectation.fulfill()
            
                
            })
        self.wait(for: [expectation], timeout: 10)

           
    }
    
    func test_F8_GivenUserWhenSentMessageThenShouldCreateFileOnServer() throws {
       let uid = "UserIdCreatedByFirebase"
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.sendMessage(to: uid, senderName: "Sender", for: "Ad Title"){ (success, error) in
            
            // Then
                XCTAssertTrue(success)
                expectation.fulfill()
            
                
            }
        self.wait(for: [expectation], timeout: 10)

           
    }
    
    func test_F9_GivenUserWhenMessageChangeThenShouldReturnTrue() throws {
        // Given
        let uid = "UserIdCreatedByFirebase"
        FirebaseService.shared.lastMessageTitle = ""
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.watchMessage(id: uid) { success, error ,result  in
            
            // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
            
        }
        self.wait(for: [expectation], timeout: 10)
        
        
    }
    
    
    
    
    func test_S1_StorageWhenSaveImageThenShouldReturnSuccess() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        guard let image = UIImage(named: "Carrots")?.pngData() else {
            return }
        
        let location = "images/\(userUID)/uniqueName.png"
            
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.saveImage(PNG: image, location: location,completionHandler:{ (success, error) in
            
            // Then
                XCTAssertTrue(success)
                expectation.fulfill()
            
                
            })
        self.wait(for: [expectation], timeout: 10)

           
    }
    
    func test_S2_StorageWhenLoadImageThenShouldReturnSuccess() throws {
       // given
        let userUID =  "UserIdCreatedByFirebase"
        let location = "images/\(userUID)/uniqueName.png"
            
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.loadImage(location, completionHandler:{ (success, error, data) in
            
            // Then
                XCTAssertTrue(success)
                expectation.fulfill()
            
                
            })
        self.wait(for: [expectation], timeout: 10)
        
        // LAST TEST IN FirebaseServiceTests
        // WE CAN DELETE FOR NEXT UNIT TESTS LAUNCH
        DeleteUser()
           
    }
    
    
    // Log out
    /*
    func test_Z0_uthWhenSignOutThenShouldSucess() throws {
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.logout( completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 10)
    
    }
    */
    
    func DeleteUser(){
        let user = Auth.auth().currentUser
        if user?.email == "test@nowaste.com"{
            user?.delete { error in
                print(" 🔴 User deleted for next test")
          
            }
            
        }
    }

    
    
    
    

}
