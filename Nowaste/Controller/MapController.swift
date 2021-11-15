//
//  ViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 28/10/2021.
//

import UIKit
import MapKit
import SwiftUI

class MapController: UIViewController {
    
    var mapView:MapView!
    
    var searchView:SearchView!

    var selectedProfiles = [Profile]()
    
    var addButton: UIButton!
    var listButton:UIButton!
    var searchButton:UIButton!
    
    var dynamicView:DynamicView!
    
    var listView: UIScrollView!
    var pageControl:UIPageControl!
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
  
        // BUTTON TO ADD AN ADVERT
        addButton = UIButton(type: .system)
        addButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        addButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        //addButton.backgroundColor = .white
        addButton.layer.cornerRadius = addButton.frame.width / 2
        addButton.addTarget(self, action:#selector(addFunction), for: .touchUpInside)
        addButton.tintColor = .init(white: 1.0, alpha: 1.0)
        
        listButton = UIButton(type: .system)
        listButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        listButton.setBackgroundImage(UIImage(systemName: "list.bullet.circle"), for: .normal)
        //listButton.backgroundColor = .white
        listButton.layer.cornerRadius = listButton.frame.width / 2
        listButton.addTarget(self, action:#selector(listFunction), for: .touchUpInside)
        listButton.tintColor = .init(white: 1.0, alpha: 1.0)
        
        searchButton = UIButton(type: .system)
        searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        //searchButton.backgroundColor = .white
        searchButton.layer.cornerRadius = searchButton.frame.width / 2
        searchButton.tintColor = .init(white: 1.0, alpha: 1.0)
        searchButton.addTarget(self, action:#selector(displaySearchToggle), for: .touchUpInside)


        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: listButton),UIBarButtonItem(customView: addButton),UIBarButtonItem(customView: searchButton) ]
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard FirebaseService.shared.listener != nil else {return}
        FirebaseService.shared.removeListener()
    }

    // MARK: - PREPARE CONTROLLER
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.overrideUserInterfaceStyle = .dark
        
        // SEARCHVIEW
        searchView = SearchView(frame: view.frame)
        view.addSubview(searchView)
        searchView.isHidden = true
        
        searchView.goButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(changeRadius), for: .touchUpInside)

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
        
        FirebaseService.shared.querryProfile(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success == true {
                self.mapView.location = CLLocationCoordinate2D(latitude: FirebaseService.shared.profile.latitude, longitude: FirebaseService.shared.profile.longitude)
            }else {
                print("error")
            }
            
        }
        
        // GET ALL USER ON THE MAP
        FirebaseService.shared.getProfiles(){success,error in
            if success {
                for document in FirebaseService.shared.profiles {
                    // CREATE ANNOTATIONS
                    let customAnnotation = Annotation(with: document)
                    self.mapView.addAnnotation(customAnnotation)
                }
                
            }else{
                print("aie")
            }
        }
        
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
        
        
        // INDICATOR
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: view.frame.midX - 100, y: view.frame.maxY - 50, width: 200, height: 20)
        view.addSubview(pageControl)
        self.pageControl.isHidden = true

    }
    
    //MARK: - ACTIONS
    
    @objc func addFunction(_ sender:UIButton) {
        let vc = AdController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func listFunction(_ sender:UIButton) {
        let vc = ListController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func changeRadius(_ sender:UIButton) {
        let radiusInM:Double = Double(searchView.slider.value * 1000 * 10) // 10 km
        let center = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
        searchView.searchDistanceLabel.text = "\(round(radiusInM) / 1000) km"
        FirebaseService.shared.getGeoHash(center: center, radiusInM: radiusInM){ success,error in
            if success {
                self.mapView.removeAnnotations(self.mapView.annotations)
                for  document in FirebaseService.shared.profiles {
                    let customAnnotation = Annotation(with: document)
                    self.mapView.addAnnotation(customAnnotation)
                }
                
            }else{
                print ("aie")
            }
            
        }
 
    }
    
    @objc func searchFunction(_ sender:UIButton) {
        selectedProfiles.removeAll()
        search(searchView.searchText.text ?? "")
    }
    
    @objc func displaySearchToggle(_ sender:UIButton) {
        if searchView.isHidden {
            searchView.isHidden = false
            searchView.animPlay()
        }else{
            searchView.animReturnToStart()
        }
    }
    
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
        mapView.removeAnnotations(mapView.annotations)
        for  document in FirebaseService.shared.profiles {
            for id in resultID {
                if document.id == id {
                    let customAnnotation = Annotation(with: document)
                    self.mapView.addAnnotation(customAnnotation)
                }
                
            }
        }
    }
    
    func getDate(dt: Double) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM YYYY - HH:mm"
        let result = dateFormatter.string(from: date)
        return result
    }
    
    @objc func didTapScrollView(_ tap: UITapGestureRecognizer) {
        
        let index = tap.view!.tag
    
        let vc = DetailController()
        vc.index = index
        navigationController?.pushViewController(vc, animated: false)
         
        
       
    }
    
    
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
            /*
            let attribText = NSMutableAttributedString(string: ad.title)
            attribText.setAttributes([NSAttributedString.Key.backgroundColor: UIColor.cyan],
                                     range: NSMakeRange(0, scrollView.itemTitle.text!.count))
            
            scrollView.itemTitle.attributedText = attribText
             */
            scrollView.itemDate.text = getDate(dt:ad.dateField)
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

