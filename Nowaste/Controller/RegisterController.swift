//
//  RegisterController.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 19/10/2021.
//

import UIKit
import Firebase
import CoreLocation

class RegisterController: UIViewController {
    
    var registerView:RegisterView!
    
    
    var topBarHeight:CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerView = RegisterView(inView: self.view)
        
        registerView.center = CGPoint(x: self.view.center.x,
                                   y: self.view.center.y)
        
        self.view.addSubview(registerView)
        
        registerView.register.addTarget(self, action:#selector(register), for: .touchUpInside)
         
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: -  ACTION
    
    func goMap() {
        let vc = MapController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // 1
    // CREATE USER
    @objc func register () {
        
        // CONVERT ADRESS TO COORDINATE ...
        let adress:String = "\(registerView.street.text!)" + "\(registerView.code.text!)" + "\(registerView.city.text!)"
        
        var coordinate = CLLocationCoordinate2D()
        
        getCoordinate(from: adress) { location in
            if location != nil {
                coordinate = location!
            }else{
                self.presentUIAlertController(title: "Adress", message: "Can't find your adress")
            }
            
        }
        // ... CREATE USER
        FirebaseService.shared.register(mail: registerView.mail.text!, pwd: registerView.password.text!) { success, error in
            if success {
                self.saveProfile(with: coordinate)
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
 
        }
        
    }
    
    // 2
    // CREATE PROFILE TO FIRESTORE WITH GEO CODE
    func saveProfile(with coordinate:CLLocationCoordinate2D){
        FirebaseService.shared.saveProfile(userName: registerView.userName.text!, latitude: coordinate.latitude, longitude: coordinate.longitude, imageURL: "images/\(FirebaseService.shared.currentUser!.uid)/profil_img.png", activeAds: 0) { success,error in
            if success {
                self.saveImageProfile()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }

        }
        
    }
    
    // 3
    // SAVE IMAGE PROFILE TO STORAGE
    func saveImageProfile(){
        FirebaseService.shared.saveImage(PNG: (registerView.imageProfile.image?.pngData())!, location: "images/\(FirebaseService.shared.currentUser!.uid)/profil_img.png"){ success,error in
            if success {
                self.goMap()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }

        }
        
    }
    
    //MARK: -  UTIL
    
    // GEO CODE GIVEN ADRESS
    func getCoordinate(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
  
    

}
