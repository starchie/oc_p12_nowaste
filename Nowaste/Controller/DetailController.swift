//
//  DetailViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 01/11/2021.
//

import UIKit

class DetailController: UIViewController {
    
 
    var index:Int!
    var detailView:DetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedItem = FirebaseService.shared.ads[index]
        
        detailView = DetailView(frame: CGRect(x: 20.0, y: 467.0, width: 335.0, height: 160.0) )

        self.view.addSubview(detailView)
        
        self.detailView.itemTitle.text = FirebaseService.shared.ads[self.index].title
        /*
        let attribText = NSMutableAttributedString(string: detailView.itemTitle.text!)
        attribText.setAttributes([NSAttributedString.Key.backgroundColor: UIColor.cyan],
                                 range: NSMakeRange(0, detailView.itemTitle.text!.count))
        
        detailView.itemTitle.attributedText = attribText
         */
        FirebaseService.shared.loadImage(selectedItem.imageURL) { success,error,image in
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
            
            self.detailView.itemDescription.text = FirebaseService.shared.ads[self.index].description
            self.detailView.countView.text = String(FirebaseService.shared.ads[self.index].likes)
            
        
            
        })
        
        
        
    }
    
   
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
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
