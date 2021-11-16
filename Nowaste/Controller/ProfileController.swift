//
//  ProfileController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 15/11/2021.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    var profileView: ProfileView!
    var tableView: UITableView!
    var ads = [Ad]()
    var selection: UILabel!
    
    var topBarHeight:CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = scene.windows.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        profileView = ProfileView(frame: CGRect(x: 10, y: topBarHeight, width: view.frame.width, height: 60))
        view.addSubview(profileView)
        
         
        profileView.userName.text = FirebaseService.shared.profile.userName
        
        
        selection = UILabel()
        selection.text = " Vos annonces sur NoWaste "
        selection.textColor = .white
        selection.frame = CGRect(x: 10, y: profileView.frame.maxY + 30, width: view.frame.width, height: 30)
        selection.font = UIFont(name: "Chalkduster", size: 18)
        view.addSubview(selection)
        
        // TABLEVIEW
        tableView = UITableView()
       
        tableView.frame = CGRect(x: 0,
                                 y: selection.frame.maxY + 30,
                                 width: view.frame.width,
                                 height: view.frame.height - (selection.frame.maxY + 30) )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        self.view.addSubview(tableView)
        
        print (FirebaseService.shared.currentUser!.uid)
        

        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FirebaseService.shared.querryAds(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success {
                self.ads = FirebaseService.shared.ads
                FirebaseService.shared.removeListener()
                self.tableView.reloadData()
                print (self.ads.count)
            }else{
                self.presentUIAlertController(title: "error", message: error!)
            }
            
        }
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    func updateActiveAdsForUser() {
        
        guard FirebaseService.shared.currentUser != nil else {
            presentUIAlertController(title: "message", message: "your are not logged")
            return}
         let value = FieldValue.increment(Int64(-1))
        
        FirebaseService.shared.updateProfile(user: FirebaseService.shared.currentUser!.uid, field: "activeAds", by: value){success,error in
             if success {
                 self.navigationController?.popViewController(animated: false)
             }else {
                 self.presentUIAlertController(title: "Enregistrement", message: error!)
             }
         }
     }
    


}

// MARK: - EXTENSION TABLEVIEW

extension ProfileController:UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        cell.textLabel?.text = ads[indexPath.row].title
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 8/255, green: 16/255, blue: 76/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = FirebaseService.shared.ads[indexPath.row].id
            print (id)
            FirebaseService.shared.deleteAd(id:id) {
                success, error in
                    if success {
                        print (self.ads.count)
                        self.updateActiveAdsForUser()
                        self.ads.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else{
                        self.presentUIAlertController(title: "error", message: error!)
                    }
                }
            }
        
        
    }

    
}

extension ProfileController:UITableViewDelegate{
    
}

