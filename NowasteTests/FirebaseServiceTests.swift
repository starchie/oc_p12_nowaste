//
//  FirebaseServiceTests.swift
//  FirebaseServiceTests
//
//  Created by Gilles Sagot on 08/11/2021.
//

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
    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
     */
    
    
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
        self.wait(for: [expectation], timeout: 1)
  
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
        self.wait(for: [expectation], timeout: 1)
  
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
        self.wait(for: [expectation], timeout: 1)
  
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
        self.wait(for: [expectation], timeout: 2)
  
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
        self.wait(for: [expectation], timeout: 2)
  
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
        self.wait(for: [expectation], timeout: 2)
  
    }
    
    func test_F2_FirestoreWhenGetAllProfilesThenShouldReturnSuccess() throws {
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.getProfiles( completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 1)
  
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
        self.wait(for: [expectation], timeout: 1)
    }
    

    func test_F4_FirestoreWhenQuerryAllAdsThenShouldSucess() throws {
       // given
    
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.getAds( completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 1)
  
    }
    
    // TODO HERE ...
    func test_F5_FirestoreWhenQuerryAnAdThenShouldSucess() throws {
       // given
        let userUID = "UserIdCreatedByFirebase"
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.querryAds(filter: userUID, completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 1)
  
    }
    
    func test_F5_FirestoreWhenUpdateAnAdThenShouldSucess() throws {
       // given
        let adUID = "AdIdCreatedByApp"
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.updateAd(field: "likes", id: adUID, by: 1, completionHandler: { (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 1)
  
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
        self.wait(for: [expectation], timeout: 1)

           
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
        self.wait(for: [expectation], timeout: 1)

           
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
        self.wait(for: [expectation], timeout: 1)

           
    }
    
    // Log out
    
    func test_Z0_uthWhenSignOutThenShouldSucess() throws {
       // given
    
        
        // when
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        FirebaseService.shared.logout( completionHandler:{ (success, error) in
            
        // Then
            XCTAssertTrue(success)
            expectation.fulfill()
            
        })
        self.wait(for: [expectation], timeout: 1)
  
    }
    
    
    
    
    
    
    

}
