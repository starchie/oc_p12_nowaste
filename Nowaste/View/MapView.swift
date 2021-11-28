//
//  MapView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 23/10/2021.

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
        
        
       let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 10000)
        setCameraZoomRange(zoomRange, animated: true)
        
        centerToLocation(location, regionRadius: CLLocationDistance(distance))
        
        
    }


}
