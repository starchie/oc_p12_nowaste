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
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.tintColor =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
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
        FirebaseService.shared.removeListener()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // SEARCHVIEW
        searchView = SearchView(frame: view.frame)
        view.addSubview(searchView)
        searchView.isHidden = true
        
        searchView.searchButton.addTarget(self, action:#selector(searchFunction), for: .touchUpInside)
        searchView.slider.addTarget(self, action: #selector(changeRadius), for: .touchUpInside)

        // MAP INIT
        self.overrideUserInterfaceStyle = .dark
        mapView = MapView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.width,
                                        height: view.frame.height))
    
        view.addSubview(mapView)
        view.sendSubviewToBack(mapView)
        
        mapView.mapType = .standard
        mapView.showsCompass = false
        
        // DELEGATE
        mapView.delegate = self
        
        // LOAD DATA FIRST
        
        FirebaseService.shared.getProfiles(){success,error in
            if success {
                for document in FirebaseService.shared.profiles {
                    print(document.activeAds)
                    // CREATE ANNOTATIONS
                    let customAnnotation = Annotation(with: document)
                    self.mapView.addAnnotation(customAnnotation)
                }
                
            }else{
                print("aie")
            }
        }

    }
    
    //MARK: - ACTION
    
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

extension MapController: MKMapViewDelegate {
    
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
    
    func mapView(_ mapView: MKMapView,viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as! Annotation
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        annotationView = AnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView!.canShowCallout = false
        
        return annotationView
        
    }

}

