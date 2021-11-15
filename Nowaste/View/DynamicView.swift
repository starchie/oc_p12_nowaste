//
//  DynamicView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 02/11/2021.
//

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
        
        shapeLayer.path = self.pathLow.cgPath
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
    
    func shapeFull() {
        // Initialize the path.
        pathFull = UIBezierPath()
  
        pathFull.move(to: CGPoint(x: 0.0, y: 50) )
        pathFull.addCurve(to: CGPoint(x: self.frame.width, y: 50),
                      controlPoint1: CGPoint(x: self.frame.width / 4, y: 0),
                      controlPoint2:CGPoint(x: self.frame.width - self.frame.width / 4, y: 0))
        
        pathFull.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        pathFull.addLine(to: CGPoint(x: 0, y: self.frame.height))
        pathFull.close()
 
    }
    
    func animInit() {
        
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

