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
    var activityIndicator = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = navigationController as! NavigationController
        nc.currentState = .register
        
        view.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        let frame = CGRect(x: 0, y: nc.topBarHeight, width: view.frame.width, height: view.frame.height - nc.topBarHeight)
        registerView = RegisterView(frame: frame)

        self.view.addSubview(registerView)
        
        registerView.register.addTarget(self, action:#selector(register), for: .touchUpInside)
        registerView.accountExist.addTarget(self, action: #selector(goLogIn), for: .touchUpInside)
        registerView.imageProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView)))
        registerView.imageProfile.isUserInteractionEnabled = true
        
        // gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
          
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        registerView.mail.textView.delegate = self
        registerView.password.textView.delegate = self
        registerView.userName.textView.resignFirstResponder()
        registerView.street.textView.delegate = self
        registerView.code.textView.delegate = self
        registerView.city.textView.delegate = self
        
        // INDICATOR
        activityIndicator.frame = CGRect(x: 0, y: view.frame.maxY - 100, width: 30, height: 30)
        activityIndicator.center.x = view.center.x
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
         
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: -  ACTIONS
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        registerView.mail.textView.resignFirstResponder()
        registerView.password.textView.resignFirstResponder()
        registerView.userName.textView.resignFirstResponder()
        registerView.street.textView.resignFirstResponder()
        registerView.code.textView.resignFirstResponder()
        registerView.city.textView.resignFirstResponder()
    }
    
    func goMap() {
        
        // ...BEFORE USE IT TO GET THE PROFILE
        FirebaseService.shared.querryProfile(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success {
                // CONTINUE TO MAP
                self.activityIndicator.stopAnimating()
                let vc = MapController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // ERROR
                self.activityIndicator.stopAnimating()
                self.presentUIAlertController(title: "Erreur", message: "Impossible de charger vos informations")
            }
            
        }
    }
    
    @objc func goLogIn() {
        self.navigationController?.popViewController(animated: true)
    }
    
    

    // 1 CREATE USER
    @objc func register () {
        
        activityIndicator.startAnimating()
        registerView.register.isEnabled = false
        
        // CONVERT ADRESS TO COORDINATE ...
        let adress:String = "\(registerView.street.textView.text!)" + "\(registerView.code.textView.text!)" + "\(registerView.city.textView.text!)"
        
        var coordinate = CLLocationCoordinate2D()
        var geohash = String()
        
        getCoordinate(from: adress) { location in
            if location != nil {
                coordinate = location!
                geohash = FirebaseService.shared.locationToHash(location: location!)
                self.saveUser(coordinate: coordinate, geohash: geohash)
            }else{
                self.presentUIAlertController(title: "Adress", message: "Can't find your location, please verify your adress.")
                self.activityIndicator.stopAnimating()
                self.registerView.register.isEnabled = true
            }
            
        }
  
    }
    
    func saveUser(coordinate:CLLocationCoordinate2D, geohash:String) {
        // ... CREATE USER UID WITH MAIL AND PASSWORD
        FirebaseService.shared.register(mail: registerView.mail.textView.text!, pwd: registerView.password.textView.text!) { success, error in
            if success {
                self.saveProfile(coordinate: coordinate, geohash: geohash)
            }else{
                self.presentUIAlertController(title: "Inscription", message: error!)
                self.activityIndicator.stopAnimating()
                self.registerView.register.isEnabled = true
            }
 
        }
        
    }
    
    // 2 CREATE PROFILE WITH FIRESTORE AND GIVE GEO CODE
    func saveProfile(coordinate:CLLocationCoordinate2D, geohash:String){

        let documentName = FirebaseService.shared.currentUser!.uid
        let date = Date().timeIntervalSince1970
        FirebaseService.shared.saveProfile(documentName: documentName, userName: registerView.userName.textView.text!,id: FirebaseService.shared.currentUser!.uid, date: date, latitude: coordinate.latitude, longitude: coordinate.longitude, imageURL: "images/\(FirebaseService.shared.currentUser!.uid)/profil_img.png", activeAds: 0, geohash: geohash) { success,error in
            if success {
                self.saveImageProfile()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
                self.activityIndicator.stopAnimating()
                self.registerView.register.isEnabled = true
            }

        }
        
    }
    
    // 3 SAVE IMAGE PROFILE TO STORAGE
    func saveImageProfile(){
        FirebaseService.shared.saveImage(PNG: (registerView.imageProfile.image?.pngData())!, location: "images/\(FirebaseService.shared.currentUser!.uid)/profil_img.png"){ success,error in
            if success {
                self.goMap()
            }else{
                self.activityIndicator.stopAnimating()
                self.presentUIAlertController(title: "Enregistrement", message: error!)
                self.registerView.register.isEnabled = true
            }

        }

    }
    
    
    // Move Keyboard automatically
    @objc func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        self.registerView.isScrollEnabled = true
        
        if registerView.street.textView.isEditing || registerView.code.textView.isEditing  || registerView.city.textView.isEditing {
            self.registerView.setContentOffset(CGPoint(x: 0, y: keyboardSize.height), animated: true)
        }
  
        

    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        self.registerView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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


//MARK: - IMAGE PICKER

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
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
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


// MARK: - UITEXTVIEW DELEGATE

extension RegisterController: UITextFieldDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }
    
}

