//
//  ListController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.
//

import UIKit
import CoreLocation

class ListController: UIViewController {
    
    // MARK: VARIABLES
    
    // TOP NAV BUTTONS
    var addButton: NavigationButton!
    var mapButton: NavigationButton!
    var searchButton: NavigationButton!
    var profileButton: NavigationButton!
    
    // SEARCH VIEW
    var searchView:SearchView!
    
    // DATA
    var ProfilesSelected = [Profile]()
    var AdsFromProfilesSelected = [Ad]()
    var distancesForProfilesSelected = [Double]()
    
    // TABLEVIEW
    var tableView: UITableView!
    var selectedRow: Int!
    var sizeForSelectedRow: CGFloat = 44
    var sizeForDefaultRow: CGFloat = 44
    
    // MARK: - PREPARE NAVIGATION CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        
        // NAVIGATION BAR
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        
        // NAVIGATION BUTTONS
        addButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "plus.circle")
        addButton.addTarget(self, action:#selector(addFunction), for: .touchUpInside)
    
        mapButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image:"map.circle")
        mapButton.addTarget(self, action:#selector(mapFunction), for: .touchUpInside)
     
        searchButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30),image: "magnifyingglass.circle")
        searchButton.addTarget(self, action:#selector(displaySearchToggle), for: .touchUpInside)
        
        profileButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30),image:"person.circle")
        profileButton.addTarget(self, action:#selector(profileFunction), for: .touchUpInside)

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mapButton),UIBarButtonItem(customView: addButton),UIBarButtonItem(customView: searchButton),UIBarButtonItem(customView: profileButton) ]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard FirebaseService.shared.listener != nil else {return}
        FirebaseService.shared.removeListener()
    }
  
    //MARK: - PREPARE CONTROLLER AND VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        // SEARCHVIEW
        searchView = SearchView(frame: view.frame)
        view.addSubview(searchView)
        searchView.isHidden = true
        searchView.goButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(getProfilesInRadius), for: .touchUpInside)
        
        // TABLEVIEW
        tableView = UITableView()
        tableView.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        tableView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.frame.width,
                                 height: view.frame.height)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListCell.self, forCellReuseIdentifier: "Cell")
        
        self.view.addSubview(tableView)
        
        // GET DATA AND UPDATE VIEWS
        
        getProfilesInRadius()
        
    }
    
    //MARK: - ACTIONS
    
    // CREATE NEW AD
    @objc func addFunction(_ sender:UIButton) {
        let vc = AdController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // GO TO MAP
    @objc func mapFunction(_ sender:UIButton) {
        let vc = MapController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // VIEW USER PROFILE
    @objc func profileFunction(_ sender:UIButton) {
        let vc = ProfileController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // VIEW DETAIL
    @objc func test(_ sender:UIButton) {
        let vc = DetailController()
        vc.currentAd = FirebaseService.shared.ads[sender.tag - 100]
        vc.isFavorite = false
        navigationController?.pushViewController(vc, animated: false)
    }
    
    //HIDE UNHIDE SEARCH VIEW
    @objc func displaySearchToggle(_ sender:UIButton) {
        if searchView.isHidden {
            searchView.animPlay()
            anim(frame: CGRect(x: 0, y: 200, width: view.frame.width, height: view.frame.height - 200))
        }else{
            searchView.animReturnToStart()
            anim(frame:  CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        }
    }
    
    @objc func searchFunction(_ sender:UIButton) {
        // CLEAN
        selectedRow = nil
        ProfilesSelected.removeAll()
        // GET
        let uid = FirebaseService.shared.searchAdsByKeyWord(searchView.searchText.text ?? "")
        FirebaseService.shared.getProfilesfromUIDList(uid) { profiles, distances in
            ProfilesSelected = profiles
            distancesForProfilesSelected = distances
        }
        // UPDATE
        tableView.reloadData()
    }
    
    
    @objc func getProfilesInRadius() {
        
        let radiusInM:Double = Double(searchView.slider.value * 1000 * 10) // 10 km
        let center = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
        
        searchView.searchDistanceLabel.text = "\(round(radiusInM / 1000)) km"
        
        FirebaseService.shared.getGeoHash(center: center, radiusInM: radiusInM){ success,error in
            if success {
                var profiles = [String]()
                
                self.ProfilesSelected = FirebaseService.shared.profiles // ARRAY WITH PROFILES
                self.distancesForProfilesSelected = FirebaseService.shared.distances // ARRAY WITH DISTANCES
                // GET ALL UID AS STRING
                for profile in FirebaseService.shared.profiles {
                    profiles.append(profile.id)
                }
                self.selectedRow = nil // NEED TO RESET TABLE VIEW - NO PROFILE SELECTED
                self.getAdsFromProfilesInRadius(profiles) // FIND ALL ADS FOR PROFILES FOUND
                
            }else{
                print ("aie")
            }
            
        }
        
    }
    
    func getAdsFromProfilesInRadius (_ profiles:[String]) {
        
        FirebaseService.shared.querryAllAds(filter: profiles) { success,error in
            if success {
                self.AdsFromProfilesSelected = FirebaseService.shared.ads
                self.tableView.reloadData()
            }else{
                print ("aie")
            }
            
        }
        
    }
    
    func anim (frame: CGRect) {
        UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: [.curveLinear], animations: {
            self.tableView.frame = frame
        }, completion: nil)
        
    }
      
}


// MARK: - EXTENSION TABLEVIEW

extension ListController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfilesSelected.count
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
        cell.removeView()
        cell.cellTitle.text = ProfilesSelected[indexPath.row].userName
        let distance = distancesForProfilesSelected[indexPath.row]
        cell.distanceView.text = "à " + String(round(distance)) + " m"
       
        if indexPath.row == selectedRow{
            
            var list = [UIButton]()
            for i in 0..<AdsFromProfilesSelected.count {
                let viewToAdd = UIButton()
                viewToAdd.contentHorizontalAlignment = .left
                viewToAdd.setTitle("\(AdsFromProfilesSelected[i].title)  > ", for: .normal)
                viewToAdd.setTitleColor(.white, for: .normal)
                viewToAdd.tag = 100 + i
                viewToAdd.addTarget(self, action: #selector(test), for: .touchUpInside)
                viewToAdd.frame = CGRect(x: cell.cellTitle.frame.minX,
                                        y: cell.cellTitle.frame.maxY * CGFloat(i) + cell.cellTitle.frame.maxY + 10,
                                        width: cell.frame.width - 40,
                                        height: cell.cellTitle.frame.height)
                    
                viewToAdd.center.x += view.frame.width
              
                list.append(viewToAdd)
            }
            cell.list = list
            cell.showSubView()
            sizeForSelectedRow = cell.totalSize + 10
            cell.anim(h: (sizeForSelectedRow - 5) )
   
            
        }else{
            cell.removeView()
            cell.anim(h: 44)
             
        }
 
        return cell
    }
    
    // USER SELECT ROW
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row // KEEP INDEX FOR UPDATE TABLEVIEW
        
        // 1 - GET PROFILE ID
        let uid = ProfilesSelected[selectedRow].id
        // 2 - SEARCH ADS FROM THIS PROFILE
        AdsFromProfilesSelected = FirebaseService.shared.searchAdsFromProfile(uid: uid)
        // 3 UPDATE
        tableView.reloadData()
    }
    
}

extension ListController:UITableViewDelegate{
    
}

