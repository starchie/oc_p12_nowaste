//
//  DetailViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 01/11/2021.
//

import UIKit

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
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
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
    
