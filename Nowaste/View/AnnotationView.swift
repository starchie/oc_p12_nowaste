//
//  AnnotationView.swift
//  Testing
//
//  Created by Gilles Sagot on 23/10/2021.
//

import Foundation
import MapKit


class AnnotationView: MKAnnotationView {
    
    var anim = UIImageView()
    var count = UILabel()
    
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      
    }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.layer.cornerRadius = 15
      
        
        anim.frame = self.frame
        self.addSubview(anim)

        anim.alpha = 1.0
        anim.animationImages = animatedImages(for: "annotation")
        anim.animationDuration = 1.4
        anim.animationRepeatCount = .zero
        anim.image = anim.animationImages?[Int.random(in: 0...2)]
        anim.startAnimating()
        
        count.frame = self.frame
        //count.backgroundColor = .white
        count.textColor = .black
        count.font = UIFont(name: "helvetica-bold", size: 12)
        count.text = "12"
        count.sizeToFit()
        count.textAlignment = .center
        self.addSubview(count)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    // MARK: - UTILS
    
    func animatedImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)_\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    
    
}
