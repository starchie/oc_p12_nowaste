//
//  MapView.swift
//  Testing
//
//  Created by Gilles Sagot on 23/10/2021.
//

import UIKit
import MapKit

class MapView: MKMapView {
    
   // var location = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
    
    var location = CLLocationCoordinate2D(latitude: 48.856614, longitude: 2.3522219) {
        didSet{
            //centerToLocation(location, regionRadius: CLLocationDistance(distance))
            setCameraMap(location)
        }
    }
    
    var distance = 500 {
        didSet{
            centerToLocation(location, regionRadius: CLLocationDistance(distance))
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        centerToLocation(location, regionRadius: CLLocationDistance(distance))
    }
    
    func centerToLocation( _ location: CLLocationCoordinate2D, regionRadius: CLLocationDistance = 500 ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
        
    }
    
    func setCameraMap( _ location: CLLocationCoordinate2D ) {
        let locationCenter = location
        
        let region = MKCoordinateRegion(center: locationCenter,
                                        latitudinalMeters: 5000,
                                        longitudinalMeters: 5000)
        
        setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region),animated: true)
        
       let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000)
        setCameraZoomRange(zoomRange, animated: true)
        
        centerToLocation(location, regionRadius: CLLocationDistance(distance))
        
    }


}
