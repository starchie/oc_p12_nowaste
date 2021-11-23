//
//  AdController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 29/10/2021.

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

class AdController: UIViewController{
    
    var adView:AdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let nc = navigationController as! NavigationController
        nc.currentState = .ad
        
        let frame = CGRect(x: 0, y: nc.topBarHeight, width: view.frame.width, height: view.frame.height - nc.topBarHeight)
        adView = AdView(frame: frame)
        
        view.addSubview(adView)
        
        adView.adImage.isUserInteractionEnabled = true
        
        self.adView.adImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView)))
        adView.adButton.addTarget(self, action:#selector(saveAd), for: .touchUpInside)
        
        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    
    @objc func saveAd(_ sender:UIButton) {
        
        guard FirebaseService.shared.currentUser != nil else {
            
            self.presentUIAlertController(title: "Enregistrement", message: "You are not connected")
            return
        }
        
        let userUID = FirebaseService.shared.currentUser!.uid
        let uniqueName:String = NSUUID().uuidString
        let storageURL = "images/\(FirebaseService.shared.currentUser!.uid)/\(uniqueName).png"
        let date = Date().timeIntervalSince1970
        
        FirebaseService.shared.setAd(userUID: userUID, id: uniqueName, title: adView.adTitle.text!, description: adView.adDescription.text!, imageURL: storageURL, date: date, likes: 0) { success, error in
            if success {
                self.saveImage(url: storageURL, uniqueName: uniqueName)
            }else {
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
        }
        
        
    }
    
    
    func saveImage(url:String, uniqueName:String) {
        
        let imageToSave = asImage(view: adView.adImage)
        
        FirebaseService.shared.saveImage(PNG: (imageToSave.pngData())!, location: "images/\(FirebaseService.shared.currentUser!.uid)/\(uniqueName).png"){ success,error in
            if success {
                self.updateActiveAdsForUser()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
            
        }
        
    }
    
    // DON'T WANT BIG DATA
    func asImage(view:UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }
    }
    
    func updateActiveAdsForUser() {
        
        guard FirebaseService.shared.currentUser != nil else {
            presentUIAlertController(title: "message", message: "your are not logged")
            return}
        let value = FieldValue.increment(Int64(1))
        
        
        FirebaseService.shared.updateProfile(user: FirebaseService.shared.currentUser!.uid, field: "activeAds", by: value){success,error in
            if success {
                self.navigationController?.popViewController(animated: false)
            }else {
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
        }
    }
    
    
}


//MARK: - IMAGE PICKER

extension AdController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self?.adView.adImage.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
