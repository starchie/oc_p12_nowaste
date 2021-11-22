//
//  DynamicView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 02/11/2021.

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

class DynamicView: UIView {


    var pathMiddle: UIBezierPath!
    var pathFull: UIBezierPath!
    var pathLow: UIBezierPath!
    
    let shapeLayer = CAShapeLayer()
    let animation = CASpringAnimation(keyPath: "path")
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.shapeLow()
        self.shapeMiddle()
        self.shapeFull()
    
        
        
        shapeLayer.fillColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0).cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    
    func shapeLow() {
        // Initialize the path.
        pathLow = UIBezierPath()
  
        pathLow.move(to: CGPoint(x: 0.0, y: self.frame.height - 0) )
        
        pathLow.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height - 0) )
        
        pathLow.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        pathLow.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        pathLow.close()
 
    }
    

    func shapeMiddle() {
        // Initialize the path.
        pathMiddle = UIBezierPath()
  
        pathMiddle.move(to: CGPoint(x: 0.0, y: self.frame.height - 200) )
        //pathStart.addLine(to: CGPoint(x: self.frame.width, y: 50) )
        pathMiddle.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height - 200),
                      controlPoint1: CGPoint(x: self.frame.width / 4, y: self.frame.height - 150),
                      controlPoint2:CGPoint(x: self.frame.width - self.frame.width / 4, y: self.frame.height - 150))
        
        pathMiddle.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height))
        pathMiddle.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        pathMiddle.close()
 
    }
    
    // Fill the view
    func shapeFull() {
        // Initialize the path.
        pathFull = UIBezierPath()
  
        pathFull.move(to: CGPoint(x: 0.0, y: 0) )
        pathFull.addLine(to: CGPoint(x: self.frame.width, y: 0))
        pathFull.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        pathFull.addLine(to: CGPoint(x: 0, y: self.frame.height))
        pathFull.close()
 
    }
    
    func animInit() {
        shapeLayer.path = self.pathLow.cgPath
        
        animation.damping = 20
        animation.initialVelocity = 1
        animation.stiffness = 800
        animation.duration =  animation.settlingDuration
        animation.toValue = pathMiddle.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
     
        
        shapeLayer.add(animation, forKey: nil)
     
        
    }
    
    func animPlay() {
        
        shapeLayer.path = self.pathMiddle.cgPath
        
        CATransaction.begin()
        animation.damping = 20
        animation.initialVelocity = 1.0
        animation.stiffness = 200
        animation.duration =  animation.settlingDuration
        animation.toValue = pathFull.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
        
        CATransaction.setCompletionBlock {
           
        }

        shapeLayer.add(animation, forKey: nil)
        CATransaction.commit()
        
    }
    
    func animReturnToStart() {
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

