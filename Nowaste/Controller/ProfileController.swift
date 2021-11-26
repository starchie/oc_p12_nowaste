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

    var choiceDescription: UILabel!
    
    var tableView: UITableView!
    
    var segmentedControl:SegmentedControl!
    
    var createdAds = [Ad]()
    var favoriteAds:[Ad]!
    
    // MARK: - PREPARE CONTROLLER AND VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PREPARE NAVIGATION CONTROLLER
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
            
        }

        // PREPARE SEGMENTED CONTROL
        segmentedControl = SegmentedControl(frame: CGRect(x: 10, y: profileView.frame.maxY + 30,
                                                 width: view.frame.width - 20,height: 80))
        
        view.addSubview(segmentedControl)
        segmentedControl.button0.addTarget(self, action: #selector(didSelectFavorite), for: .touchUpInside)
        segmentedControl.button1.addTarget(self, action: #selector(didSelectCreated), for: .touchUpInside)
        segmentedControl.selectedSegmentIndex = 0
        
        // LABEL : CHOICE DESCRIPTION - FAVORITE OR CREATED ADS
        choiceDescription = UILabel()
        choiceDescription.textColor = .white
        choiceDescription.text = "Vos annonces sauvegardé sur NoWaste "
        choiceDescription.font = UIFont(name: "Helvetica-Bold", size: 28)
        choiceDescription.numberOfLines = 0
        choiceDescription.adjustsFontSizeToFitWidth = true
        choiceDescription.frame = CGRect(x: 20, y: segmentedControl.frame.maxY + 30,
                                         width: view.frame.width - 40, height: 60)
        

        view.addSubview(choiceDescription)
        
        // PREPARE TABLEVIEW
        tableView = UITableView()
       
        tableView.frame = CGRect(x: 0,
                                 y: choiceDescription.frame.maxY + 30,
                                 width: view.frame.width,
                                 height: view.frame.height - (choiceDescription.frame.maxY + 30) )
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.6)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 80)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
 
        self.view.addSubview(tableView)

    }
    
    // LOAD WHEN CONTROLLER APPEAR
    override func viewWillAppear(_ animated: Bool) {
        // GET DATA
        getCreatedAds()
        favoriteAds = CoreDataManager.shared.all
        tableView.reloadData()
    }
    
    // MARK: - ACTIONS
    
    // SELECTION CHANGE BETWEEN FAVORITES AND CREATED ADS
    @objc func didSelectFavorite(){
        segmentedControl.selectedSegmentIndex = 0
        choiceDescription.text = "Vos annonces sauvegardé sur NoWaste "
        tableView.reloadData()
    }
    
    @objc func didSelectCreated(){
        segmentedControl.selectedSegmentIndex = 1
        choiceDescription.text = "Vos annonces crées sur NoWaste "
        tableView.reloadData()
    }
    
    // GET ADS CREATED BY USER
    func getCreatedAds(){
        
        guard FirebaseService.shared.currentUser != nil else {
            presentUIAlertController(title: "message", message: "your are not logged")
            return
        }
        // GET ADS
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
    
    // HOW MANY CELL TO BUILD
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 1 {
            return createdAds.count
        }else{
            return favoriteAds.count
        }
    }
    
    // CELL HEIGHT
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // CELL STYLE
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // FOR ALL CELLS
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = .clear
        cell.imageView?.tintColor = .white
        
        // CELL WILL DISPLAY CREATED ADS
        if segmentedControl.selectedSegmentIndex == 1 {
            cell.textLabel?.text = createdAds[indexPath.row].title
            cell.detailTextLabel?.text = FirebaseService.shared.getDate(dt: createdAds[indexPath.row].dateField)
            cell.imageView?.image = UIImage(systemName: "doc.richtext")
        }
        // CELL WILL DISPLAY FAVORITE
        else {
            cell.textLabel?.text = favoriteAds[indexPath.row].title
            cell.detailTextLabel?.text = FirebaseService.shared.getDate(dt: favoriteAds[indexPath.row].dateField)
            let message = CoreDataManager.shared.returnMessage(from: CoreDataManager.shared.all[indexPath.row].id)
            if message == true {
                cell.imageView?.image = UIImage(systemName: "mail")
            }
            else{
                cell.imageView?.image = UIImage(systemName: "star")
            }
            
        }
        
        return cell
    }
    
    // USER SELECT A CELL : PREPARE NEXT CONTROLLER VIEW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailController()
        
        if segmentedControl.selectedSegmentIndex == 1 {
            let profile = FirebaseService.shared.profile
            vc.selectedProfile = profile
            vc.currentAd = FirebaseService.shared.ads[indexPath.row]
            vc.isUserCreation = true
            vc.isFavorite = false
        }
        else {
            let profile = CoreDataManager.shared.returnProfile(from: CoreDataManager.shared.all[indexPath.row].id)
            vc.selectedProfile = profile.first
            vc.currentAd = CoreDataManager.shared.all[indexPath.row]
            vc.isUserCreation = false
            vc.isFavorite = true
            
        }
       
        navigationController?.pushViewController(vc, animated: false)
        
    }

    
}

extension ProfileController:UITableViewDelegate{
    
}

