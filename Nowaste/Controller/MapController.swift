//
//  ViewController.swift
//  Nowaste
//
//  Created by Gilles Sagot on 28/10/2021.
//

import UIKit
import MapKit

class MapController: UIViewController {
    
    var mapView:MapView!
    
    var searchView:SearchView!

    var selectedProfiles = [Profile]()
    
    var addButton: UIButton!
    var listButton:UIButton!
    var searchButton:UIButton!
    
    var topBarHeight:CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = scene.windows.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
       
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        // BUTTON TO ADD AN ADVERT
        addButton = UIButton(type: .system)
        addButton.setBackgroundImage(UIImage(systemName: "plus.circle"), for: .normal)
        addButton.addTarget(self, action:#selector(addFunction), for: .touchUpInside)
        addButton.tintColor = .init(white: 1.0, alpha: 1.0)
        
        listButton = UIButton(type: .system)
        listButton.setBackgroundImage(UIImage(systemName: "list.bullet.indent"), for: .normal)
        listButton.addTarget(self, action:#selector(listFunction), for: .touchUpInside)
        listButton.tintColor = .init(white: 1.0, alpha: 1.0)
       
        searchButton = UIButton(type: .system)
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        searchButton.tintColor = .init(white: 1.0, alpha: 1.0)
        searchButton.addTarget(self, action:#selector(displaySearchToggle), for: .touchUpInside)
       
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: listButton),UIBarButtonItem(customView: addButton), UIBarButtonItem(customView: searchButton)]
        
        
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
        
        searchView.searchButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(changeRadius), for: .touchUpInside)

        // MAP INIT
        mapView = MapView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.mapType = .standard
        
        mapView.showsCompass = false
        mapView.showsTraffic = false
        
        // DELEGATE
        mapView.delegate = self
        
        // LOAD DATA FIRST
        
        // PLACE CAMERA - USER GEO LOCATION -
        FirebaseService.shared.querryProfile(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success {
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
        search(searchView.searchText.text)
    }
    
    @objc func displaySearchToggle(_ sender:UIButton) {
        if searchView.isHidden {
            searchView.isHidden = false
        }else{
            searchView.isHidden = true
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
    
    
}

// MARK: EXTENSION MAP DELEGATE

extension MapController: MKMapViewDelegate {
    
    // MARK: - PLACE ANNOTATIONS
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as! Annotation
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = false
        
        return annotationView
        
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
                let render = UIGraphicsImageRenderer(size: self.mapView.bounds.size)
                let image:UIImage? = render.image { ctx in
                    self.mapView.drawHierarchy(in: self.mapView.bounds, afterScreenUpdates: true)
                }
                
                let vc = HorizontalScrollController()
                vc.backgroundView.image = image
                vc.backgroundView.frame = mapView.frame
                self.navigationController?.pushViewController(vc, animated: false)
    
            }else{
                print("can't present controller ")
            }
            
        }
    }

}

