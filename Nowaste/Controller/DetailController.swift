//
//  DetailViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 01/11/2021.
//

import UIKit

class DetailController: UIViewController {
    
 
    var currentAd: Ad!
    var detailView:DetailView!
    var favoriteButton:UIButton!
    var trashButton:UIButton!
    var isFavorite = false
    var isUserCreation = false

    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // NAVIGATION BAR
        navigationController?.navigationBar.isHidden = false
    
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: favoriteButton),UIBarButtonItem(customView: trashButton)]

        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailView = DetailView(frame: CGRect(x: 20.0, y: 467.0, width: 335.0, height: 160.0) )

        self.view.addSubview(detailView)
        
        self.detailView.itemTitle.text = currentAd.title
        /*
        let attribText = NSMutableAttributedString(string: detailView.itemTitle.text!)
        attribText.setAttributes([NSAttributedString.Key.backgroundColor: UIColor.cyan],
                                 range: NSMakeRange(0, detailView.itemTitle.text!.count))
        
        detailView.itemTitle.attributedText = attribText
         */
        FirebaseService.shared.loadImage(currentAd.imageURL) { success,error,image in
            if success {
                self.detailView.itemImage.image = UIImage(data: image!)
                
            }else {
                self.presentUIAlertController(title: "erreur", message: error!)
            }
            
        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.3, options: [], animations: {
            
            self.detailView.frame = self.view.frame
        }, completion: { (finished: Bool) in
            self.detailView.updateViews()
            
            self.detailView.itemDescription.text = self.currentAd.description
            self.detailView.countView.text = String(self.currentAd.likes)
            
        
            
        })
        
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
        
        FavoriteAd.saveAdToFavorite (userUID: currentAd.addedByUser, id: currentAd.id, title: currentAd.title, description: currentAd.description, imageURL: currentAd.imageURL, date: currentAd.dateField, likes: currentAd.likes)

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


















/*
class DetailController: UIViewController {
    
    var dynamicView:DynamicView!
    var detailview: DetailView!
    var index:Int!
    
    var topBarHeight:CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = scene.windows.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }

    override func viewWillAppear(_ animated: Bool) {

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FirebaseService.shared.removeListener()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // VIEW
        let width: CGFloat = view.frame.width
        let height: CGFloat = view.frame.height - topBarHeight - 200
        
        dynamicView = DynamicView(frame: CGRect(x: 0, y: 200, width: width, height: height) )
        dynamicView.animPlay()
        dynamicView.alpha = 0.8
       
        view.addSubview(dynamicView)
        
        // DETAILVIEW
        detailview = DetailView(frame: view.frame)
        self.view.addSubview(detailview)
       
        print(FirebaseService.shared.ads.count)
        
        let selectedItem = FirebaseService.shared.ads[index]
        detailview.isHidden = false
        detailview.itemTitle.text = selectedItem.title
        detailview.itemDescription.text = selectedItem.description
        detailview.countView.text = "+ " + String(selectedItem.likes)
        FirebaseService.shared.loadImage(selectedItem.imageURL) { success,error,image in
            if success {
                self.detailview.itemImage.image = UIImage(data: image!)
                
            }else {
                self.presentUIAlertController(title: "erreur", message: error!)
            }
            
        }
        detailview.contactButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        
      
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func sendMessage() {
        let value: Int = FirebaseService.shared.ads[index].likes + 1
        
        FirebaseService.shared.updateAd(field: "likes",
                                        id: FirebaseService.shared.ads[index].id,
                                        by: value) { success, error in
            if success {
                self.presentUIAlertController(title: "Info", message: "You sent a message ")
                let selectedItem = FirebaseService.shared.ads[self.index]
                self.detailview.countView.text = "+ " + String(selectedItem.likes)
                
            }else{
                self.presentUIAlertController(title: "error", message: error!)
            }
            
            
        }
        
    }
    
}
*/
