//
//  AppDelegate.swift
//  Nowaste
//
//  Created by Gilles Sagot on 28/10/2021.

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




import UIKit
import Firebase
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - COREDATA
    
    static var container = ContainerManager().persistentContainer
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        //return container
        return AppDelegate.container!
    }()
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // END DATA



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Firestore.firestore().settings.isPersistenceEnabled = false
        
        // CHECKING IF UNIT TESTS ARE RUNNING
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
            print("🍏 Setting up Firestore emulator localhost:8080")
            print("🍐 Setting up Authentication emulator localhost:9099")
            print("🥝 Setting up Storage emulator localhost:9199")
            let settingsFirestore = Firestore.firestore().settings
            settingsFirestore.host = "localhost:8080"
            settingsFirestore.isPersistenceEnabled = false
            settingsFirestore.isSSLEnabled = false
            Firestore.firestore().settings = settingsFirestore
            
            Auth.auth().useEmulator(withHost:"localhost", port:9099)
            Storage.storage().useEmulator(withHost:"localhost", port:9199)
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

