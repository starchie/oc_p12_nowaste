//
//  AdController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 29/10/2021.
//

import UIKit
import Firebase

class AdController: UIViewController{
    
    var adView:AdView!
    
    var topBarHeight:CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = scene.windows.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        let frame = CGRect(x: 0, y: topBarHeight, width: view.frame.width, height: view.frame.height - topBarHeight)
        adView = AdView(frame: frame)
        view.addSubview(adView)
        self.adView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnImageView)))
        
        
        adView.adButton.addTarget(self, action:#selector(saveAd), for: .touchUpInside)
        
       
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - ACTION
    
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


//MARK:- IMAGE PICKER

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
