//
//  RegisterController.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 19/10/2021.

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
import CoreLocation

class RegisterController: UIViewController {
    
    var registerView:RegisterView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = navigationController as! NavigationController
        nc.currentState = .register
        
        view.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
 
        registerView = RegisterView(inView: self.view)

        registerView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + nc.topBarHeight)
        self.view.addSubview(registerView)
        
        registerView.register.addTarget(self, action:#selector(register), for: .touchUpInside)
        registerView.imageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView)))
        registerView.imageProfile.isUserInteractionEnabled = true
        
         
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: -  ACTIONS
    
    func goMap() {
        let vc = MapController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    // 1 CREATE USER
    @objc func register () {
        
        // CONVERT ADRESS TO COORDINATE ...
        let adress:String = "\(registerView.street.text!)" + "\(registerView.code.text!)" + "\(registerView.city.text!)"
        
        var coordinate = CLLocationCoordinate2D()
        var geohash = String()
        
        getCoordinate(from: adress) { location in
            if location != nil {
                coordinate = location!
                geohash = FirebaseService.shared.locationToHash(location: location!)
                self.saveUser(coordinate: coordinate, geohash: geohash)
            }else{
                self.presentUIAlertController(title: "Adress", message: "Can't find your location, please verify your adress.")
                
            }
            
        }
  
    }
    
    func saveUser(coordinate:CLLocationCoordinate2D, geohash:String) {
        // ... CREATE USER UID WITH MAIL AND PASSWORD
        FirebaseService.shared.register(mail: registerView.mail.text!, pwd: registerView.password.text!) { success, error in
            if success {
                self.saveProfile(coordinate: coordinate, geohash: geohash)
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
 
        }
        
    }
    
    // 2 CREATE PROFILE WITH FIRESTORE AND GIVE GEO CODE
    func saveProfile(coordinate:CLLocationCoordinate2D, geohash:String){
        guard FirebaseService.shared.currentUser != nil else {
            self.presentUIAlertController(title: "Enregistrement", message: "you are not logged")
            return
        }
        let documentName = FirebaseService.shared.currentUser!.uid + "_profile"
        let date = Date().timeIntervalSince1970
        FirebaseService.shared.saveProfile(documentName: documentName, userName: registerView.userName.text!,id: FirebaseService.shared.currentUser!.uid, date: date, latitude: coordinate.latitude, longitude: coordinate.longitude, imageURL: "images/\(FirebaseService.shared.currentUser!.uid)/profil_img.png", activeAds: 0, geohash: geohash) { success,error in
            if success {
                self.saveImageProfile()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }

        }
        
    }
    
    // 3 SAVE IMAGE PROFILE TO STORAGE
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
    
    // 4 GEO CODE GIVEN ADRESS
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


//MARK:- IMAGE PICKER

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
   @objc func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showAlert()
    }

    //Show alert to selected the media source type.
    private func showAlert() {

        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        self.dismiss(animated: true) { [weak self] in

            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            //Setting image to your image view
            self?.registerView.imageProfile.image = image
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

