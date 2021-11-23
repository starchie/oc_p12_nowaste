//
//  ProfileController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 15/11/2021.

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

class ProfileController: UIViewController {
    
    var profileView: ProfileView!

    var selection: UILabel!
    var control:UISegmentedControl!
    var tableView: UITableView!
    
    
    var createdAds = [Ad]()
    var favoriteAds:[Ad]!
    
    // MARK: - PREPARE CONTROLLER AND VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FavoriteAd.deleteAllCoreDataItems()
        
        // NAVIGATION CONTROLLER
        let nc = navigationController as! NavigationController
        nc.currentState = .profile
        
        // PREPARE VIEWS
        view.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        // PROFILE VIEW HOW WE ARE
        profileView = ProfileView(frame: CGRect(x: 10, y: nc.topBarHeight, width: view.frame.width, height: 60))
        view.addSubview(profileView)
        
        // GET PROFILE NAME
        guard FirebaseService.shared.profile != nil else{ return }
        profileView.userName.text = FirebaseService.shared.profile.userName
        
        // GET PROFILE IMAGE
        FirebaseService.shared.loadImage(FirebaseService.shared.profile.imageURL) { success,error,image in
            if success {
                self.profileView.imageProfile.image = UIImage(data: image!)
                
            }else {
                self.presentUIAlertController(title: "erreur", message: error!)
            }
            
        }// End Closure
        
        // SEGMENTED CONTROL
        let items: [String] = ["✍︎","✮"]
        control = UISegmentedControl(items: items)
        control.tintColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        control.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        control.frame = CGRect(x: 10, y: profileView.frame.maxY + 30, width: view.frame.width - 20, height: 30)
        control.layer.cornerRadius = 0
        control.selectedSegmentTintColor = .darkGray
        view.addSubview(control)
        // SEGMENTED CONTROL ACTION
        control.addTarget(self, action: #selector(didChange(_:)), for: .valueChanged)
  
        
        // LABEL : CHOICE DESCRIPTION - FAVORITE OR CREATED ADS
        selection = UILabel()
        selection.text = " Vos annonces sur NoWaste "
        selection.textColor = .white
        selection.frame = CGRect(x: 10, y: control.frame.maxY + 30, width: view.frame.width, height: 30)
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

    }
    
    // RELOAD
    override func viewWillAppear(_ animated: Bool) {
        // GET DATA
        getCreatedAds()
        favoriteAds = FavoriteAd.all
        tableView.reloadData()
    }
    
    // MARK: - ACTIONS
    
    // SELECTION CHANGE BETWEEN FAVORITES AND CREATED ADS
    @objc func didChange(_ sender: UISegmentedControl){
        tableView.reloadData()
    }
    
    // ADS FROM USER
    func getCreatedAds(){
        
        guard FirebaseService.shared.currentUser != nil else {
            presentUIAlertController(title: "message", message: "your are not logged")
            return}
        
        FirebaseService.shared.querryAds(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success {
                self.createdAds = FirebaseService.shared.ads
                self.tableView.reloadData()
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

}

// MARK: - EXTENSION TABLEVIEW

extension ProfileController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if control.selectedSegmentIndex == 0 {
            return createdAds.count
        }else{
            return favoriteAds.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 8/255, green: 16/255, blue: 76/255, alpha: 1.0)
        
        if control.selectedSegmentIndex == 0 {
            cell.textLabel?.text = createdAds[indexPath.row].title
            cell.imageView?.tintColor = .white
            cell.imageView?.image = UIImage(systemName: "")
        }
        else {
            cell.textLabel?.text = favoriteAds[indexPath.row].title
            let message = FavoriteMessage.returnUser(from: FavoriteAd.all[indexPath.row].id)
            if message == true {
                cell.imageView?.tintColor = .white
                cell.imageView?.image = UIImage(systemName: "mail")
            }
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailController()
        if control.selectedSegmentIndex == 0 {
            let profile = FirebaseService.shared.profile
            vc.selectedProfile = profile
            vc.currentAd = FirebaseService.shared.ads[indexPath.row]
            vc.isUserCreation = true
            vc.isFavorite = false
        }
        else {
            let profile = FavoriteProfile.returnUser(from: FavoriteAd.all[indexPath.row].id)
            vc.selectedProfile = profile.first
            vc.currentAd = FavoriteAd.all[indexPath.row]
            vc.isUserCreation = false
            vc.isFavorite = true
            
        }
       
        navigationController?.pushViewController(vc, animated: false)
        
    }

    
}

extension ProfileController:UITableViewDelegate{
    
}

