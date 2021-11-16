//
//  AppDelegate.swift
//  Nowaste
//
//  Created by Gilles Sagot on 28/10/2021.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Firestore.firestore().settings.isPersistenceEnabled = false
        
        // Checking if unit tests are running
        
        if ProcessInfo.processInfo.environment["unit_tests"] == "true" {
            print("🍎 Setting up Firebase emulator localhost:8080")
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

