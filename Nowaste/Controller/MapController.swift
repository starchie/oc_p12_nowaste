//
//  ViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 28/10/2021.

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
import MapKit
import SwiftUI

class MapController: UIViewController {
    
    // TOP NAV BUTTONS
    var addButton:NavigationButton!
    var listButton:NavigationButton!
    var searchButton:NavigationButton!
    var profileButton:NavigationButton!
    
    // VIEWS
    var mapView:MapView!
    var searchView:SearchView!
    var dynamicView:DynamicView!
    var listView: UIScrollView!
    var pageControl:UIPageControl!
    
    // DATA
    var sortedProfiles = [Profile]()
    var AdsFromSortedProfiles = [Ad]()
    var selectedProfile:Profile!
    
    
    // MARK: - PREPARE NAVIGATION CONTROLLER
    
    override func viewWillAppear(_ animated: Bool) {
        
        // NAVIGATION BAR
        navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
  
        // // NAVIGATION BUTTONS
        addButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "plus.circle")
        addButton.addTarget(self, action:#selector(addFunction), for: .touchUpInside)
        
        listButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "list.bullet.circle")
        listButton.addTarget(self, action:#selector(listFunction), for: .touchUpInside)

        searchButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "magnifyingglass.circle")
        searchButton.addTarget(self, action:#selector(displaySearchToggle), for: .touchUpInside)
        
        profileButton = NavigationButton(frame: CGRect(x:0, y:0, width:30, height:30), image: "person.circle")
        profileButton.addTarget(self, action:#selector(profileFunction), for: .touchUpInside)

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: listButton),UIBarButtonItem(customView: addButton),UIBarButtonItem(customView: searchButton), UIBarButtonItem(customView: profileButton) ]
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard FirebaseService.shared.listener != nil else {return}
        FirebaseService.shared.removeListener()
    }

    // MARK: - PREPARE CONTROLLER AND VIEWS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.overrideUserInterfaceStyle = .dark
        
        // SEARCHVIEW
        searchView = SearchView(frame: view.frame)
        view.addSubview(searchView)
        searchView.isHidden = true
        
        searchView.goButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(getProfilesInRadius), for: .touchUpInside)

        // MAP INIT
        mapView = MapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.mapType = .mutedStandard
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsCompass = false
        mapView.showsTraffic = false
        
        // DELEGATE
        mapView.delegate = self
        
        // LOAD DATA FIRST
        // PLACE CAMERA - USER GEO LOCATION -
        
        guard FirebaseService.shared.currentUser?.uid != nil, FirebaseService.shared.profile != nil
        else { self.presentUIAlertController(title: "Erreur", message: "Vous n'êtes pas connecté"); return}
        
        FirebaseService.shared.querryProfile(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success == true {
                self.mapView.location = CLLocationCoordinate2D(latitude: FirebaseService.shared.profile.latitude, longitude: FirebaseService.shared.profile.longitude)
            }else {
                print("error")
            }
            
        }
        
        // GET ALL USER ON THE MAP
        getProfilesInRadius()
        
        // DYNAMIC VIEW
        let width: CGFloat = view.frame.width
        let height: CGFloat = 200
        
        dynamicView = DynamicView(frame: CGRect(x: 0, y: self.view.frame.maxY - height, width: width, height: height) )
        dynamicView.alpha = 1.0
        dynamicView.isHidden = true
       
        view.addSubview(dynamicView)
        
        
        // LIST
        listView = UIScrollView()
        listView.isPagingEnabled = true
        listView.delegate = self;
        listView.frame = CGRect(x: 0,
                                y: (view.frame.maxY) - 200,
                                width: view.frame.width,
                                height: 200)
    
        view.addSubview(listView)
        
        
        // PAGE CONTROL
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: view.frame.midX - 100, y: view.frame.maxY - 50, width: 200, height: 20)
        view.addSubview(pageControl)
        self.pageControl.isHidden = true

    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - ACTIONS
    
    // CREATE NEW AD
    @objc func addFunction(_ sender:UIButton) {
        let vc = AdController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // GO TO LIST
    @objc func listFunction(_ sender:UIButton) {
        let vc = ListController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // VIEW USER PROFILE
    @objc func profileFunction(_ sender:UIButton) {
        let vc = ProfileController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // VIEW DETAIL
    @objc func didTapScrollView(_ tap: UITapGestureRecognizer) {
        let index = tap.view!.tag
        let vc = DetailController()
        vc.currentAd = FirebaseService.shared.ads[index]
        vc.isFavorite = false
        vc.selectedProfile = selectedProfile
        navigationController?.pushViewController(vc, animated: false)
        
    }
    
    //HIDE UNHIDE SEARCH VIEW
    @objc func displaySearchToggle(_ sender:UIButton) {
        if searchView.isHidden {
            searchView.animPlay()
        }else{
            searchView.animReturnToStart()
        }
    }
    
    @objc func getProfilesInRadius() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        let latitude = FirebaseService.shared.profile.latitude
        let longitude = FirebaseService.shared.profile.longitude
        
        let radiusInM:Double = Double(searchView.slider.value * 1000 * 10) // 10 km
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        searchView.searchDistanceLabel.text = "\(round(radiusInM) / 1000) km"
        FirebaseService.shared.getGeoHash(center: center, radiusInM: radiusInM){ success,error in
            if success {
                var profiles = [String]()
                
                self.sortedProfiles = FirebaseService.shared.profiles // ARRAY WITH PROFILES
            
        
                // GET ALL UID AS STRING
                for profile in self.sortedProfiles {
                    profiles.append(profile.id)
                    let customAnnotation = Annotation(with: profile)
                    self.mapView.addAnnotation(customAnnotation)
                }
                print ("profiles : \(profiles.count)")
                guard profiles.count > 0 else {return}
                self.getAdsFromProfilesInRadius(profiles) // FIND ALL ADS FOR PROFILES FOUND
            }else{
                print ("aie")
            }
            
        }
 
    }
    
    func getAdsFromProfilesInRadius (_ profiles:[String]) {

        FirebaseService.shared.querryAllAds(filter: profiles) { success,error in
            if success {
                self.AdsFromSortedProfiles = FirebaseService.shared.ads
            }else{
                print ("aie")
            }
            
        }
        
    }
    
    @objc func searchFunction(_ sender:UIButton) {
        // CLEAN
        sortedProfiles.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        // GET
        // IF SEARCH HAS NOTHING -> RESET
        if searchView.searchText.text == "" {
            sortedProfiles = FirebaseService.shared.profiles
            for  profile in sortedProfiles {
                let customAnnotation = Annotation(with: profile)
                self.mapView.addAnnotation(customAnnotation)
            }
        }else {
            let uid = FirebaseService.shared.searchAdsByKeyWord(searchView.searchText.text ?? "")
            FirebaseService.shared.getProfilesfromUIDList(uid) { profiles, distances in
                sortedProfiles = profiles
            }
            // UPDATE
            for  profile in sortedProfiles {
                let customAnnotation = Annotation(with: profile)
                self.mapView.addAnnotation(customAnnotation)
            }
            
        }// End else
    
        
    }// End func

}



// MARK: EXTENSION MAP DELEGATE

extension MapController: MKMapViewDelegate {
    
    // MARK: - PLACE ANNOTATIONS
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as! Annotation
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
        let marker = annotationView as! AnnotationView
    
        let size = 30 + (3 * annotation.profile!.activeAds)
        annotationView?.frame = CGRect(x: 0, y: 0, width: size, height: size)
        marker.anim.frame = annotationView!.frame
        marker.count.text = String(annotation.profile!.activeAds)
        marker.count.center = annotationView!.center
        marker.layer.cornerRadius = CGFloat(size / 2)
        marker.canShowCallout = false
        
        return marker
        
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        listView.isHidden = true
        self.pageControl.isHidden = true
        self.dynamicView.animReturnToStart()
        
    }
    
    // MARK: - DID SELECT AN ANNOTATION
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let selectedAnnotations = mapView.selectedAnnotations
        for annotation in selectedAnnotations {
              mapView.deselectAnnotation(annotation, animated: false)
        }
    
        let annotation = view.annotation as! Annotation
        guard annotation.profile?.activeAds ?? 0 > 0 else {return}
        selectedProfile = annotation.profile
       
        FirebaseService.shared.querryAds(filter: annotation.profile!.id) {success,error in
            if success {
                // CREATE LIST SUBVIEWS
                self.listView.isHidden = false
                self.dynamicView.isHidden = false
                self.dynamicView.animInit()
                self.pageControl.isHidden = false
                self.pageControl.numberOfPages = FirebaseService.shared.ads.count
                self.pageControl.currentPage = 0
                
                for subView in self.listView.subviews{
                    subView.removeFromSuperview()
                }
                
                if self.listView.subviews.count < FirebaseService.shared.ads.count {
                    while let view = self.listView.viewWithTag(0) {
                        view.tag = 1000
                    }

                }
                self.setupList()
            }else{
                print("can't present controller ")
            }
            
        }
        
    }

}

// MARK: - CONTROLLER EXTENSION SCROLL LIST

extension MapController : UIScrollViewDelegate{
    
    // PREPARE VIEWS
    
    func setupList() {
    
        self.listView.setContentOffset(.zero, animated: false)
        self.listView.reloadInputViews()
        
        for i in FirebaseService.shared.ads.indices {
            
            // CREATE VIEW
            let scrollView = HorizontalScrollView(frame: listView.bounds)
            let ad = FirebaseService.shared.ads[i]
            
            scrollView.itemTitle.text = ad.title
            scrollView.itemDate.text = FirebaseService.shared.getDate(dt:ad.dateField)
            scrollView.tag = i
            scrollView.isUserInteractionEnabled = true
            
            listView.addSubview(scrollView)
            
            scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapScrollView)))
        }
        
        listView.backgroundColor = UIColor.clear
        positionListItems()
    }
    
    // VIEWS POSITION IN LIST
    
    func positionListItems() {
        let listHeight = listView.frame.height
        let itemHeight: CGFloat = listHeight - 40
        let itemWidth: CGFloat = view.frame.width - 40
        
        let horizontalPadding: CGFloat = 40
        
        for i in FirebaseService.shared.ads.indices {
            let imageView = listView.viewWithTag(i) as! HorizontalScrollView
            imageView.frame = CGRect(
                x: CGFloat(i) * itemWidth + CGFloat(i+1) * horizontalPadding - 20,
                y: 0.0,
                width: itemWidth,
                height: itemHeight)
        }
        
        listView.contentSize = CGSize(width: CGFloat(FirebaseService.shared.ads.count) * (itemWidth + horizontalPadding) + horizontalPadding, height:  0)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    

    
}

