//
//  ListController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.

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
import CoreLocation

class ListController: UIViewController {
    
    // MARK: VARIABLES
    
    // TOP NAV BUTTONS
    var addButton = NavigationButton()
    var mapButton = NavigationButton()
    var searchButton = NavigationButton()
    var profileButton = NavigationButton()
    
    // SEARCH VIEW
    var searchView = SearchView()
    

    var sortedProfiles = [Profile]()
    var AdsFromSortedProfiles = [Ad]()
    var distancesForSortedProfiles = [Double]()
    var selectedProfile:Profile!
    var adsForSelectedProfile = [Ad]()
    
    // TABLEVIEW
    var tableView = UITableView()
    var selectedRow:Int!
    var sizeForSelectedRow: CGFloat = 60
    var sizeForDefaultRow: CGFloat = 60
    
    var activityIndicator = UIActivityIndicatorView()
    
    // MARK: - PREPARE NAVIGATION CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        
        // NAVIGATION BAR
        let nc = navigationController as! NavigationController
        nc.currentState = .list
        
        // NAVIGATION BUTTONS
        addButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "plusCircle")
        addButton.addTarget(self, action:#selector(addFunction), for: .touchUpInside)
    
        mapButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image:"mapCircle")
        mapButton.addTarget(self, action:#selector(mapFunction), for: .touchUpInside)
     
        searchButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30),image: "magnifyingGlassCircle")
        searchButton.addTarget(self, action:#selector(displaySearchToggle), for: .touchUpInside)
        
        profileButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30),image:"personCircle")
        profileButton.addTarget(self, action:#selector(profileFunction), for: .touchUpInside)

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mapButton),UIBarButtonItem(customView: addButton),UIBarButtonItem(customView: searchButton),UIBarButtonItem(customView: profileButton) ]
        
        
        // GET DATA AND UPDATE VIEWS
        getProfilesInRadius()

    }
    
    //MARK: - PREPARE CONTROLLER AND VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SET BACKGROUND
        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        // SEARCHVIEW
        searchView = SearchView(frame: view.frame)
        view.addSubview(searchView)
        searchView.isHidden = true
        searchView.goButton.addTarget(self, action:#selector(searchThisWordInAds), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(getProfilesInRadius), for: .touchUpInside)
        
        // SEARCHVIEW DELEGATE TEXT
        searchView.searchText.delegate = self
        // SEARCHVIEW GESTURE RECOGNIZER
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.searchView.addGestureRecognizer(tap)
        
        // PREPARE TABLEVIEW
        tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .init(white: 1.0, alpha: 0.1)
        tableView.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.width,
                                 height: view.frame.height - 30)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView)
        
        // ACTIVITY INDICATOR
        activityIndicator.frame = CGRect(x: 0, y: view.frame.maxY - 30, width: 30, height: 30)
        activityIndicator.center.x = view.center.x
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    
    // TAP ANYWHERE TO LEAVE SEARCH TEXT
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        searchView.searchText.resignFirstResponder()

    }
    
    // CREATE NEW AD
    @objc func addFunction(_ sender:UIButton) {
        let vc = AdController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // GO TO MAP
    @objc func mapFunction(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    // VIEW USER PROFILE
    @objc func profileFunction(_ sender:UIButton) {
        let vc = ProfileController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // VIEW DETAIL
    @objc func goDetail(_ sender:UIButton) {
        let vc = DetailController()
        vc.currentAd = adsForSelectedProfile[sender.tag - 100]
        vc.selectedProfile = selectedProfile
        vc.isFavorite = false
        navigationController?.pushViewController(vc, animated: false)
    }
    
    // TOGGLE DISPLAY SEARCH VIEW
    @objc func displaySearchToggle(_ sender:UIButton) {
        if searchView.isHidden {
            searchView.animPlay()
            anim(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 200))
        }else{
            searchView.animReturnToStart()
            anim(frame:  CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        }
    }
    
    @objc func searchThisWordInAds() {
        // CLEAN
        selectedRow = nil
        sortedProfiles.removeAll()
        
        // THIS FUNCTION WORKS WITHOUT FIREBASE.
        // IT SEARCHS IN PROFILES AND ADS FROM MODEL ALREADY DOWNLOAD WITH SEARCHBYRADIUS FUNCTION
        
        // FIRST CASE:
        // IF SEARCH TEXT IS EMPTY -> RETURN EVERYTHING
        if searchView.searchText.text == "" {
            sortedProfiles = FirebaseService.shared.profiles
            distancesForSortedProfiles = FirebaseService.shared.distances
            
            // WE WILL NOT DISPLAY PROFIL WITH ANY AD IN THE TABLEVIEW
            // SO CALL FUNCTION FROM MODEL TO DELETE :
            FirebaseService.shared.removeProfileIfNoAd(self.sortedProfiles, distances: self.distancesForSortedProfiles){ resultProfiles,resultDistances in
                // UPDATE PROFILES BUT ALSO DISTANCES
                self.sortedProfiles = resultProfiles
                self.distancesForSortedProfiles = resultDistances
            }

            // UPDATE TABLE
            tableView.reloadData()
        }
        // SECOND CASE:
        // IF SERACH TEXT NOT EMPTY :
        else {
            // SEARCH IF THERE IS A MATCH WITH MODEL FUNCTION
            // IF THERE IS, THIS FUNCTION WILL RETURN AN ARRAY WITH ALL PROFILE UID
            let uid = FirebaseService.shared.searchAdsByKeyWord(searchView.searchText.text ?? "", array: FirebaseService.shared.ads)
            if uid.isEmpty {
                presentUIAlertController(title: "Recherche", message: "Aucun resultat trouvé")
                return
            }else {
            // THEN UPDATE PROFILE ARRAY WITH ANOTHER MODEL FUNCTION
            FirebaseService.shared.getProfilesfromUIDList(uid, arrayProfiles: FirebaseService.shared.profiles, arrayDistances: FirebaseService.shared.distances) { profiles, distances in
                sortedProfiles = profiles
                distancesForSortedProfiles = distances
            }
            
            // UPDATE TABLE
            tableView.reloadData()
            }
        }
    
    }
    
    
    @objc func getProfilesInRadius() {
        // WE CANT DOWNLAD ALL THE DATA FROM FIREBASE SO WE SELECT ALL PROFILES
        // AND THEIR ADS IN RADIUS FROM USER LOCATION
        
        // IT CAN TAKE SOME TIME
        activityIndicator.startAnimating()
        
        // GET CURRENT LOCATION
        let latitude = FirebaseService.shared.profile.latitude
        let longitude = FirebaseService.shared.profile.longitude
        // RADIUS
        let radiusInM:Double = Double(searchView.slider.value * 1000 * 4) // 4 km
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        searchView.searchDistanceLabel.text = "\(round(radiusInM) / 1000) km"
        // CALL FIREBASE MODEL FUNCTION :
        FirebaseService.shared.getGeoHash(center: center, radiusInM: radiusInM){ success,error in
            if success {
                var profiles = [String]()
                // UPDATE ARRAYS
                self.sortedProfiles = FirebaseService.shared.profiles // ARRAY WITH PROFILES
                self.distancesForSortedProfiles = FirebaseService.shared.distances // ARRAY WITH DISTANCES
                
                // AVOID PROFILES WITH ANY AD. WE DON'T WANT TO DISPLAY THEM IN LIST
                FirebaseService.shared.removeProfileIfNoAd(self.sortedProfiles, distances: self.distancesForSortedProfiles){ resultProfiles,resultDistances in
                    self.sortedProfiles = resultProfiles
                    self.distancesForSortedProfiles = resultDistances
                }

                // GET ALL UID AS STRING
                for profile in self.sortedProfiles {
                    profiles.append(profile.id)
                }
                // IF NOBODY : UPDATE AND SHOW MESSAGE
                if profiles.count == 0 {
                    self.sortedProfiles = []
                    self.AdsFromSortedProfiles = []
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }else {
                    self.selectedRow = nil // NEED TO RESET TABLE VIEW - NO PROFILE SELECTED
                    self.getAdsFromProfilesInRadius(profiles) // FIND ALL ADS FOR PROFILES FOUND
                }
                
                
            }else{
                self.activityIndicator.stopAnimating()
                self.presentUIAlertController(title: "Error", message: error!)
            }
            
        }
        
    }
    
    func getAdsFromProfilesInRadius (_ profiles:[String]) {
        // WE HAVE A LIST OF PROFILES THEN GET ALL ADS FROM THEM
        FirebaseService.shared.querryAllAds(filter: profiles) { success,error in
            if success {
                // UPDATE
                self.AdsFromSortedProfiles = FirebaseService.shared.ads
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }else{
                self.activityIndicator.stopAnimating()
                self.presentUIAlertController(title: "Error", message: error!)
            }
            
        }
        
    }
    // ANIMATION
    func anim (frame: CGRect) {
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: [.curveLinear], animations: {
            self.tableView.frame = frame
        }, completion: nil)
        
    }
      
}


// MARK: - EXTENSION TABLEVIEW

extension ListController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedProfiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRow {
            return sizeForSelectedRow
           } else {
            return sizeForDefaultRow
           }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListCell
        // CLEAN
        cell.removeView()
        
        // UPDATE LAYOUT
        let text = sortedProfiles[indexPath.row].userName
        let distance = distancesForSortedProfiles[indexPath.row]
        let distanceText = "à " + String(round(distance)) + " m"
        cell.layoutFirstLine(title: text, distance: distanceText)
        let cellImage = UIImage(named: "annotationBlue") ?? UIImage()
        cell.changeImage(image: cellImage)

   
        // IF SELECTED ROW DISPLAY ADS FOR SELECTED USER
        if indexPath.row == selectedRow{
            
            var buttons = [UIButton]()
            for i in 0..<adsForSelectedProfile.count {
                let buttonToAdd = UIButton()
                buttonToAdd.contentHorizontalAlignment = .left
                buttonToAdd.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
                buttonToAdd.titleLabel?.adjustsFontSizeToFitWidth = true
                buttonToAdd.setTitle("\(adsForSelectedProfile[i].title)  > ", for: .normal)
                buttonToAdd.setTitleColor(.white, for: .normal)
                buttonToAdd.tag = 100 + i
                buttonToAdd.addTarget(self, action: #selector(goDetail), for: .touchUpInside)
                buttonToAdd.frame = CGRect(x: cell.cellTitle.frame.minX,
                                         y: cell.cellTitle.frame.maxY + CGFloat(i * 30),
                                         width: cell.frame.width - 40,
                                         height: 30)
                    
                buttonToAdd.center.x += view.frame.width
              
                buttons.append(buttonToAdd)
            }
             
            cell.buttons = buttons // UPDATE LIST
            cell.showSubView() // DISPLAY BUTTONS JUST CREATED
            sizeForSelectedRow = cell.totalSize + 20 // UPDATE THE HEIGHT CELL
            cell.anim(refSize:sizeForSelectedRow) // ANIMATION
   
            
        }else{
            cell.removeView()
            cell.anim(refSize:60)
             
        }
 
        return cell
    }
    
    // USER SELECT ROW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // KEEP INDEX FOR UPDATE TABLEVIEW
        selectedRow = indexPath.row
        
        // 1 - GET PROFILE ID
        let uid = sortedProfiles[selectedRow].id
        selectedProfile = sortedProfiles[selectedRow]
        // 2 - SEARCH ADS FROM THIS PROFILE
        adsForSelectedProfile = FirebaseService.shared.searchAdsFromProfile(uid: uid, array: FirebaseService.shared.ads)
        // 3 UPDATE
        tableView.reloadData()
    }
    
}

extension ListController:UITableViewDelegate{
    
}


// MARK: - EXTENSION UITEXTFIELD DELEGATE

extension ListController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            searchThisWordInAds()
        }
    }
        
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }
    
}

