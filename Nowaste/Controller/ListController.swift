//
//  ListController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.
//

import UIKit
import CoreLocation

class ListController: UIViewController {
    
    var addButton: UIButton!
    var mapButton: UIButton!
    var searchButton: UIButton!
    
    var searchView:SearchView!
    
    var selectedProfiles = [Profile]()
    
    var tableView: UITableView!
    var selectedRow: IndexPath!
    var sizeForSelectedRow: CGFloat = 44
    var sizeForDefaultRow: CGFloat = 44
    
    var topBarHeight:CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = scene.windows.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }
    
    // MARK: - NAVIGATION CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        
        // NAVIGATION BAR
        navigationController?.navigationBar.isHidden = false
        /*
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        */
        // BUTTON TO ADD AN ADVERT
        addButton = UIButton(type: .system)
        addButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        //addButton.backgroundColor = .white
        addButton.layer.cornerRadius = addButton.frame.width / 2
        addButton.addTarget(self, action:#selector(addFunction), for: .touchUpInside)
        addButton.tintColor = .init(white: 1.0, alpha: 1.0)
        
        mapButton = UIButton(type: .system)
        mapButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        mapButton.setBackgroundImage(UIImage(systemName: "map.circle"), for: .normal)
        //mapButton.backgroundColor = .white
        mapButton.layer.cornerRadius = mapButton.frame.width / 2
        mapButton.addTarget(self, action:#selector(mapFunction), for: .touchUpInside)
        mapButton.tintColor = .init(white: 1.0, alpha: 1.0)
        
        searchButton = UIButton(type: .system)
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        //searchButton.backgroundColor = .white
        searchButton.layer.cornerRadius = searchButton.frame.width / 2
        searchButton.tintColor = .init(white: 1.0, alpha: 1.0)
        searchButton.addTarget(self, action:#selector(displaySearchToggle), for: .touchUpInside)

        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: mapButton),UIBarButtonItem(customView: addButton),UIBarButtonItem(customView: searchButton)]

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard FirebaseService.shared.listener != nil else {return}
        FirebaseService.shared.removeListener()
    }
  
//MARK: - PREPARE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(red: 8/255, green: 16/255, blue: 76/255, alpha: 1.0)
        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        // SEARCHVIEW
        searchView = SearchView(frame: view.frame)
        view.addSubview(searchView)
        searchView.isHidden = true
        
        searchView.goButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(changeRadius), for: .touchUpInside)
        
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
        
        // LOAD DATA WITH FIREBASE FIRST
        
        let radiusInM:Double = Double(searchView.slider.value * 1000 * 10) // 10 km
        let center = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
        FirebaseService.shared.getGeoHash(center: center, radiusInM: radiusInM){ success,error in
            if success {
               self.selectedProfiles = FirebaseService.shared.profiles
               self.tableView.reloadData()
            }else{
                print ("aie")
            }
            
        }

    }
    
    //MARK: - ACTION
    
    // NEW AD
    @objc func addFunction(_ sender:UIButton) {
        let vc = AdController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // MAP
    @objc func mapFunction(_ sender:UIButton) {
        let vc = MapController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // DISPLAY SELECTED AD
    @objc func test(_ sender:UIButton) {
        let vc = DetailController()
        vc.index = sender.tag - 100
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @objc func displaySearchToggle(_ sender:UIButton) {
        if searchView.isHidden {
            searchView.isHidden = false
            searchView.animPlay()
        
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: [.curveLinear], animations: {
                self.tableView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.height - 200)
            }, completion: nil)
            
        }else{
            searchView.animReturnToStart()
            UIView.animate(withDuration: 0.5, delay: 0,usingSpringWithDamping: 0.3, initialSpringVelocity: 0.4, options: [.curveLinear], animations: {
                self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: nil)
          
        }
    }
    
    @objc func searchFunction(_ sender:UIButton) {
        selectedRow = nil
        selectedProfiles.removeAll()
        search(searchView.searchText.text ?? "")
    }
    
    @objc func changeRadius(_ sender:UIButton) {
        let radiusInM:Double = Double(searchView.slider.value * 1000 * 10) // 10 km
        let center = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
        searchView.searchDistanceLabel.text = "\(round(radiusInM / 1000)) km"
        FirebaseService.shared.getGeoHash(center: center, radiusInM: radiusInM){ success,error in
            if success {
               self.selectedProfiles = FirebaseService.shared.profiles
               self.tableView.reloadData()
            }else{
                print ("aie")
            }
            
        }
 
    }
    
    // MARK: - FILTERS AND SEARCH
    
    func search(_ item:String){
        var resultID = [String]()
        
        FirebaseService.shared.getAds() {success,error in
            if success {
                for document in FirebaseService.shared.ads {
                    let objc = document.title
                    let string = item
                    if objc.range(of: string, options: .caseInsensitive) != nil {
                        resultID.append(document.addedByUser)
                    }
                
                }
                
                self.update(resultID:resultID)
                  
            }else{
                print("aie")
            }
    
        }
        
        
    }
    
    func update(resultID: [String]){
        for  document in FirebaseService.shared.profiles {
            for id in resultID {
                if document.id == id {
                    selectedProfiles.append(document)
                    print ("selectedProfiles: \(selectedProfiles.count)")
                }
                
            }
        }
        tableView.reloadData()
    }
    
    

}


// MARK: - EXTENSION TABLEVIEW

extension ListController:UITableViewDataSource {
    
    func updateTableViewIfReady(){
        
        let id = selectedProfiles[selectedRow.row].id
        
        FirebaseService.shared.querryAds(filter: "\(id)") { success,error in
                if success {
                    self.tableView.reloadData()
                }else{
                    print("aie")
                }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedProfiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedRow {
            return sizeForSelectedRow
           } else {
            return sizeForDefaultRow
           }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListCell
        cell.removeView()
        cell.cellTitle.text = selectedProfiles[indexPath.row].userName
        let distance = FirebaseService.shared.distances[indexPath.row]
        cell.distanceView.text = "à " + String(round(distance)) + " m"
       
        if indexPath == selectedRow{
            
            var list = [UIButton]()
            for i in 0..<FirebaseService.shared.ads.count {
                let viewToAdd = UIButton()
                viewToAdd.contentHorizontalAlignment = .left
                viewToAdd.setTitle("\(FirebaseService.shared.ads[i].title)  > ", for: .normal)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath
        updateTableViewIfReady()
    }
    
}

extension ListController:UITableViewDelegate{
    
}

