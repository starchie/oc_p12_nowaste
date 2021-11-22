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

class DetailController: UIViewController {
    
 
    var currentAd: Ad!
    var detailView:DetailView!
    var favoriteButton:UIButton!
    var trashButton:UIButton!
    var isFavorite = false
    var isUserCreation = false
    var dynamicView: DynamicView!
    var selectedProfile: Profile!

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // NAVIGATION BAR
        navigationController?.navigationBar.isHidden = false
    
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: favoriteButton),UIBarButtonItem(customView: trashButton)]

        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = navigationController as! NavigationController
        nc.currentState = .detail
        
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
        
        
        self.detailView.itemTitle.text = currentAd.title
        self.detailView.itemDescription.text = currentAd.description
        self.detailView.countView.text = String(currentAd.likes)
        self.detailView.card.nameProfile.text = selectedProfile.userName
        

        
        FirebaseService.shared.loadImage(currentAd.imageURL) { success,error,image in
            if success {
                self.detailView.itemImage.image = UIImage(data: image!)
                
            }else {
                self.presentUIAlertController(title: "erreur", message: error!)
            }
            
        }
         

        // BUTTONS
        favoriteButton = UIButton(type: .system)
        favoriteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        favoriteButton.setBackgroundImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.layer.cornerRadius = favoriteButton.frame.width / 2
        favoriteButton.tintColor = .init(white: 1.0, alpha: 1.0)
        favoriteButton.addTarget(self, action:#selector(toggleFavorite), for: .touchUpInside)
        
        trashButton = UIButton(type: .system)
        trashButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        trashButton.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
        trashButton.layer.cornerRadius = favoriteButton.frame.width / 2
        trashButton.tintColor = .init(white: 1.0, alpha: 1.0)
        //trashButton.addTarget(self, action:#selector(toggleFavorite), for: .touchUpInside)
        
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        if isUserCreation {
            trashButton.isHidden = false
        }
        else {
            trashButton.isHidden = true
        }
        
        
        
    }
    
   
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    //MARK: -  ACTION
    
    func addToFavorite() {
        
        FavoriteAd.saveAdToFavorite (userUID: currentAd.addedByUser, id: currentAd.id, title: currentAd.title, description: currentAd.description, imageURL: currentAd.imageURL, date: currentAd.dateField, likes: currentAd.likes, profile: selectedProfile)

        presentUIAlertController(title: "Info", message: "Recipe saved")
        
        print("🍏 adding ...")
        print(FavoriteAd.all.count)
        
    }
        
    func deleteFromFavorite() {
    
        FavoriteAd.deleteAd(id: currentAd.id)
        presentUIAlertController(title: "Info", message: "Recipe deleted")
     
        print("🍎 deleting ...")
        print(FavoriteAd.all.count)
    }
    
    @objc func toggleFavorite() {
        // Attempt to customize navigation controller...
        
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            isFavorite = false
            deleteFromFavorite()
        }
        else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            isFavorite = true
            addToFavorite()
        }


  
    }
    
}
