//
//  DetailViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 01/11/2021.

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

class DetailController: UIViewController {
    
 
    var currentAd:Ad!
    var detailView = DetailView()
    var favoriteButton = NavigationButton()
    var trashButton = NavigationButton()
    var isFavorite = false
    var isUserCreation = false
    var dynamicView = DynamicView()
    var selectedProfile:Profile!

    // THIS CONTROLLER IS USED WITH DIFFERENT STATES :
    // DISPLAY AN AD : SO USER CAN ADD TO FAVORITE AND / OR SEND EMAIL
    // DISPLAY A FAVORITE ADD : USER CAN DELETE FROM HIS FAVORITES
    // DISPLAY AN AD FROM CURRENT USER : SO HIDE MAIL AND FAVORITE
    // COME FROM HIS PROFILE AND WANT TO DELETE FROM SOURCE HIS AD : SO DISPLAY TRASH
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // NAVIGATION CONTROLLER
        let nc = navigationController as! NavigationController
        nc.currentState = .detail
        
        // PREPARE NAVIGATION BUTTONS
        prepareNavigationButton()
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: favoriteButton),UIBarButtonItem(customView: trashButton)]
        
        // VIEWS
        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        detailView = DetailView(frame: CGRect(x: 0, y: nc.topBarHeight, width: view.frame.width, height: view.frame.height - nc.topBarHeight) )
        self.view.addSubview(detailView)
        
        // DYNAMIC VIEW
        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height
        dynamicView = DynamicView(frame: CGRect(x: 0, y: 0, width: width, height: height) )
        dynamicView.alpha = 1.0
        view.addSubview(dynamicView)
        view.sendSubviewToBack(dynamicView)
        dynamicView.animPlay()
        
        // DETAIL VIEW
        detailView.itemTitle.text = currentAd.title
        detailView.itemDescription.text = currentAd.description
        detailView.countView.text = String(currentAd.likes)
        detailView.card.nameProfile.text = selectedProfile.userName
        detailView.contactButton.addTarget(self, action:#selector(sendMail), for: .touchUpInside)
        
        // HIDE THIS IF AD IS FROM CURRENT USER
        if selectedProfile.id == FirebaseService.shared.currentUser?.uid {
            detailView.contactButton.isHidden = true
            favoriteButton.isHidden = true
        }

        // GET IMAGE FROM AD
        FirebaseService.shared.loadImage(currentAd.imageURL) { success,error,image in
            if success {
                self.detailView.itemImage.image = UIImage(data: image!)
                
            }else {
                self.presentUIAlertController(title: "erreur", message: error!)
            }
            
        }// End Closure

    }
 

    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    //MARK: -  ACTIONS
    
    // NAVIGATION STATE
    func prepareNavigationButton () {
        // BUTTONS
        favoriteButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "star")
        favoriteButton.addTarget(self, action:#selector(toggleFavorite), for: .touchUpInside)
        
        trashButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "trash")
        trashButton.addTarget(self, action:#selector(deleteAd), for: .touchUpInside)
        
        if isFavorite {
            favoriteButton.setBackgroundImage(UIImage(named:"starFill"), for: .normal)
        }else {
            favoriteButton.setBackgroundImage(UIImage(named: "star"), for: .normal)
        }
        
        if isUserCreation {
            trashButton.isHidden = false
            favoriteButton.isHidden = true
        }
        else {
            trashButton.isHidden = true
            favoriteButton.isHidden = false
        }
        
    }
    
    // SEND MAIL
    @objc func sendMail() {
        // UPDATE MESSAGE
        FirebaseService.shared.sendMessage(to: selectedProfile.id, senderName: FirebaseService.shared.profile.userName, for: currentAd.title) {success, error in
            if success {
                // check if ad already exist
                if CoreDataManager.shared.findAd(id: self.currentAd.id) {
                    CoreDataManager.shared.deleteAd(id: self.currentAd.id)
                }
                // UPDATE FIELD 'LIKES' FOR THIS AD AS USER SENT EMAIL...
                self.addLike ()
                
                // SAVE TO COREDATA FAVORITE WITH MAIL TRUE
                CoreDataManager.shared.saveAdToFavorite (userUID: self.currentAd.addedByUser, id: self.currentAd.id, title: self.currentAd.title, description: self.currentAd.description, imageURL: self.currentAd.imageURL, date: self.currentAd.dateField, likes: self.currentAd.likes, profile: self.selectedProfile, contact: true)
                // INFORM USER
                self.presentUIAlertController(title: "Info", message: " Vous avez envoyé un mail à \(self.selectedProfile.userName), vous pouvez retrouver cette annonce dans vos favoris. Merci d'utiliser Nowaste :)")
            }
            else {
                self.presentUIAlertController(title: "Erreur", message: error!)
            }
            
        }

    }
    
    // FUNC TO UPDATE FIELD 'LIKES' FOR THIS AD
    func addLike () {
        let value = FieldValue.increment(Int64(1))
        
        FirebaseService.shared.updateAd(ad: currentAd.id, field: "likes", by: value){ success, error in
            if success {
                print ("likes updated")
            }else {
                print ("cant't edit ad")
            }
            
        }
        
    }
    
    // FUNC TO SAVE TO FAVORITE WITH MAIL FALSE
    func addToFavorite() {
        
        // Check if ad already exist
        if CoreDataManager.shared.findAd(id: self.currentAd.id) {
            presentUIAlertController(title: "Info", message: "Annonce déjà dans vos favoris.")
            return
        }
        // Add ad
        CoreDataManager.shared.saveAdToFavorite (userUID: currentAd.addedByUser, id: currentAd.id, title: currentAd.title, description: currentAd.description, imageURL: currentAd.imageURL, date: currentAd.dateField, likes: currentAd.likes, profile: selectedProfile, contact: false)

        presentUIAlertController(title: "Info", message: "Annonce enregistrée")
        
    }
    
    // FUNC DELETE FROM FAVORITE
    func deleteFromFavorite() {
        CoreDataManager.shared.deleteAd(id: currentAd.id)
        presentUIAlertController(title: "Info", message: "Annonce supprimée")
    }
    
    // AD WAS CREATED BY USER SO HE CAN DELETE IT
    @objc func deleteAd(){
        let id = currentAd.id
        FirebaseService.shared.deleteAd(id:id) {
            success, error in
                if success {
                    self.updateActiveAdsForUser()
                } else{
                    // INFORM USER THAT IT'S DONE
                    self.presentUIAlertController(title: "error", message: error!)
                }
            }
    }
    
    // DELETE AD AND ALSO IMAGE FROM CLOUD
    func deleteImageFromCloud() {
        FirebaseService.shared.deleteImage(currentAd.imageURL) {
            success, error in
            if success {
                self.presentUIAlertController(title: "Suppression", message: "post supprimé avec succés")
            }else {
                self.presentUIAlertController(title: "Erreur", message: "Une erreur est survenue")
                
            }
        }
    }
    
    // IF WE DELETE AN AD, CHANGE AD COUNTER IN PROFILE
    func updateActiveAdsForUser() {
        
        guard FirebaseService.shared.currentUser != nil else {
            presentUIAlertController(title: "message", message: "your are not logged")
            return}
         let value = FieldValue.increment(Int64(-1))
        
        FirebaseService.shared.updateProfile(user: FirebaseService.shared.currentUser!.uid, field: "activeAds", by: value){success,error in
             if success {
                 self.deleteImageFromCloud()
             }else {
                 self.presentUIAlertController(title: "Enregistrement", message: error!)
             }
         }
     }
    
    // TOGGLE FAVORITE ADD TO COREDATA OR DELETE FROM COREDATA
    @objc func toggleFavorite() {
        
        if isFavorite {
            favoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
            isFavorite = false
            deleteFromFavorite()
        }
        else {
            favoriteButton.setBackgroundImage(UIImage(systemName: "star.fill"), for: .normal)
            isFavorite = true
            addToFavorite()
        }


  
    }
    
}
