//
//  AnnotationView.swift
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

import Foundation
import MapKit


class AnnotationView: MKAnnotationView {
    
    var anim = UIImageView()
    var count = UILabel()
    var title = UILabel()
    
    
    // Required for MKAnnotationView
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

        self.backgroundColor = .clear
        
        anim.frame = self.frame
        self.addSubview(anim)
        
        anim.alpha = 1.0
        anim.image = UIImage(named: "annotationBlue")
        anim.animationImages = animatedImages(for: "annotation")
        anim.animationDuration = 1.4
        anim.animationRepeatCount = .zero
        anim.startAnimating()
        
        count.frame = self.frame
        //count.backgroundColor = .white
        count.textColor = .black
        count.font = UIFont(name: "helvetica-bold", size: 12)
        count.text = "12"
        count.sizeToFit()
        count.textAlignment = .center
        self.addSubview(count)
        
        title.text = "userName"
        title.font = UIFont(name: "helvetica", size: 14)
        title.textColor = .white
        title.sizeToFit()
        title.center = CGPoint(x: self.center.x, y: self.frame.maxY + 10)
        self.addSubview(title)
        
    }
    
    func updateView (size: CGFloat, text:String, number:Int, test:Bool) {
        
        self.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        title.text = text
        title.sizeToFit()
        title.center = CGPoint(x: self.center.x, y: self.frame.maxY + 10)
        
        anim.frame = self.frame
        
        count.text = String(number)
        count.frame = self.frame
        count.center = self.center
        
        if test == true {
            anim.stopAnimating()
        }
        
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
