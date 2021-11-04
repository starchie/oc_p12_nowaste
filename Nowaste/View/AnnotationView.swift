//
//  AnnotationView.swift
//  Testing
//
//  Created by Gilles Sagot on 23/10/2021.
//

import Foundation
import MapKit


class AnnotationView: MKAnnotationView {
    
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
    }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      
        self.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(red: 85/255,
                                      green: 85/255,
                                      blue: 192/255,
                                      alpha: 1.0)
        
  
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    
    
}
