//
//  SearchView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.
//

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

class SearchView: UIView {
    
    var goButton:UIButton!
    var searchText:UITextField!
    var line: UIView!
    var slider: UISlider!
    var searchDistanceLabel: UILabel!
    
    var pathMiddle: UIBezierPath!
    var pathFull: UIBezierPath!
    var pathLow: UIBezierPath!
    
    let shapeLayer = CAShapeLayer()
    let animation = CASpringAnimation(keyPath: "path")
    
    enum searchStates {
        case idle, search
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: 200)
        self.backgroundColor =  .clear
        
        self.shapeLow()
        self.shapeFull()
        
        shapeLayer.path = self.pathLow.cgPath
        shapeLayer.fillColor =  UIColor(white: 0.5, alpha: 1.0).cgColor
        
        self.layer.addSublayer(shapeLayer)
        
     
        
        searchText = UITextField()
        searchText.placeholder = "Légume ou fruit "
        self.addSubview(searchText)
        searchText.frame = CGRect(x: 85, y: 130, width: frame.width - 170, height: 40)
        searchText.font = UIFont(name: "Helvetica-Bold", size: 21)
        searchText.adjustsFontSizeToFitWidth = true
        searchText.textColor = UIColor.white
        searchText.textAlignment = .center
        
        
        line = UIView()
        line.frame = CGRect(x: 85, y: 170, width: frame.width - 170, height: 1)
        line.backgroundColor = .white
        self.addSubview(line)
        
        goButton = UIButton()
        self.addSubview(goButton)
        goButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)
        goButton.tintColor = .init(white: 1.0, alpha: 1.0)
        goButton.frame = CGRect(x: line.frame.maxX + 5, y: line.frame.minY - 30, width: 20, height: 20)
        
        
        slider = UISlider()
        self.addSubview(slider)
        slider.tintColor = .white
        slider.value = 1
        slider.frame = CGRect(x: 40, y: 100, width: frame.width - 100, height: 20)
        
        searchDistanceLabel = UILabel()
        self.addSubview(searchDistanceLabel)
        searchDistanceLabel.textColor = .white
        searchDistanceLabel.adjustsFontSizeToFitWidth = true
        searchDistanceLabel.font = UIFont(name: "Helvetica-Bold", size: 12)
        searchDistanceLabel.text = "10 km"
        searchDistanceLabel.frame = CGRect(x: slider.frame.maxX + 5,
                                           y: 100,
                                           width: self.frame.width - ( slider.frame.maxX + 10 ),
                                           height: 30)
     
       
    }
    
    func shapeLow() {
        // Initialize the path.
        pathLow = UIBezierPath()
  
        pathLow.move(to: CGPoint(x: 0.0, y: 0.0) )
        pathLow.addLine(to: CGPoint(x: self.frame.width, y: 0.0 ) )
        pathLow.addLine(to: CGPoint(x: self.frame.width, y: 0.0))
        pathLow.addLine(to: CGPoint(x: 0, y: 0.0))
        pathLow.close()
 
    }
    
    func shapeFull() {
        // Initialize the path.
        pathFull = UIBezierPath()
  
        pathFull.move(to: CGPoint(x: 0.0, y: 0.0) )
        pathFull.addLine(to: CGPoint(x: self.frame.width, y: 0.0))
        pathFull.addLine(to: CGPoint(x: self.frame.width, y: 150))
        pathFull.addCurve(to: CGPoint(x: 0.0, y: 150),
                      controlPoint1: CGPoint(x:self.frame.width - self.frame.width / 4 , y: 150 + 50),
                      controlPoint2:CGPoint(x: self.frame.width / 4, y: 150 + 50))
        
      
      
        pathFull.close()
 
    }
    
    func animPlay() {
        
        goButton.isHidden = false
        searchText.isHidden = false
        line.isHidden = false
        slider.isHidden = false
        searchDistanceLabel.isHidden = false
        self.isHidden = false
        
        animation.damping = 20
        animation.initialVelocity = 1
        animation.stiffness = 800
        animation.duration =  animation.settlingDuration
        animation.toValue = pathFull.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
   
        shapeLayer.add(animation, forKey: nil)
        
        
    }
    
    func animReturnToStart() {
        
        goButton.isHidden = true
        searchText.isHidden = true
        line.isHidden = true
        slider.isHidden = true
        searchDistanceLabel.isHidden = true
        
        CATransaction.begin()
        animation.damping = 20
        animation.initialVelocity = 1
        animation.stiffness = 800
        animation.duration =  animation.settlingDuration
        animation.toValue = pathLow.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
        
        CATransaction.setCompletionBlock {
            self.shapeLayer.path = self.pathLow.cgPath
            self.shapeLayer.removeAllAnimations()
            self.isHidden = true
        }
    
        shapeLayer.add(animation, forKey: nil)
        CATransaction.commit()
        
    }
}
