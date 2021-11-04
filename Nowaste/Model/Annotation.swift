//
//  TestAnotation.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 17/10/2021.
//
import MapKit

class Annotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    var profile: Profile?
    
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    init(with profile: Profile){
        self.title = profile.userName
        self.locationName = profile.userName
        self.coordinate = CLLocationCoordinate2D(latitude: profile.latitude,
                                                 longitude: profile.longitude)
        
        self.profile = profile
        
        super.init()
    }
    
    var subtitle: String? {
        return "par " + "\(locationName ?? " ")"
    }
    
}

