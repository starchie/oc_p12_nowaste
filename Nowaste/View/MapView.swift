//
//  MapView.swift
//  Testing
//
//  Created by Gilles Sagot on 23/10/2021.
//

import UIKit
import MapKit

class MapView: MKMapView {
    
    var location = CLLocationCoordinate2D(latitude: 48.8127729, longitude: 2.5203043)
    
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


}
