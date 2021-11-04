//
//  DynamicView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 02/11/2021.
//

import UIKit

class DynamicView: UIView {


    var pathStart: UIBezierPath!
    var pathEnd: UIBezierPath!
    var pathInit: UIBezierPath!
    
    let shapeLayer = CAShapeLayer()
    let animation = CASpringAnimation(keyPath: "path")
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        self.shapeInit()
        self.shapeStart()
        self.shapeEnd()
        
        shapeLayer.path = self.pathInit.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(shapeLayer)
        self.animInit()
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
       
    }
    
    func shapeInit() {
        // Initialize the path.
        pathInit = UIBezierPath()
  
        pathInit.move(to: CGPoint(x: 0.0, y: self.frame.height - 50) )
        
        pathInit.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height - 50) )
        
        pathInit.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        pathInit.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        pathInit.close()
 
    }
    

    func shapeStart() {
        // Initialize the path.
        pathStart = UIBezierPath()
  
        pathStart.move(to: CGPoint(x: 0.0, y: self.frame.height - 200) )
        //pathStart.addLine(to: CGPoint(x: self.frame.width, y: 50) )
        pathStart.addCurve(to: CGPoint(x: self.frame.width, y: self.frame.height - 200),
                      controlPoint1: CGPoint(x: self.frame.width / 4, y: self.frame.height - 150),
                      controlPoint2:CGPoint(x: self.frame.width - self.frame.width / 4, y: self.frame.height - 150))
        
        pathStart.addLine(to: CGPoint(x: self.frame.width, y: self.frame.size.height))
        pathStart.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        pathStart.close()
 
    }
    
    func shapeEnd() {
        // Initialize the path.
        pathEnd = UIBezierPath()
  
        pathEnd.move(to: CGPoint(x: 0.0, y: 50) )
        pathEnd.addCurve(to: CGPoint(x: self.frame.width, y: 50),
                      controlPoint1: CGPoint(x: self.frame.width / 4, y: 0),
                      controlPoint2:CGPoint(x: self.frame.width - self.frame.width / 4, y: 0))
        
        pathEnd.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        pathEnd.addLine(to: CGPoint(x: 0, y: self.frame.height))
        pathEnd.close()
 
    }
    
    func animInit() {
        
        animation.damping = 20
        animation.initialVelocity = 1
        animation.stiffness = 800
        animation.duration =  animation.settlingDuration
        animation.toValue = pathStart.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
     
        
        shapeLayer.add(animation, forKey: nil)
     
        
    }
    
    

    func animPlay() {
        
        
        animation.damping = 20
        animation.initialVelocity = 1
        animation.stiffness = 800
        animation.duration =  animation.settlingDuration
        animation.toValue = pathEnd.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
        

     
        
        shapeLayer.add(animation, forKey: nil)
        
        
    }
    
    func animReversse() {
        CATransaction.begin()
        animation.damping = 20
        animation.initialVelocity = 1
        animation.stiffness = 800
        animation.duration =  animation.settlingDuration
        animation.toValue = pathStart.cgPath
        
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards;
        
        CATransaction.setCompletionBlock {
            self.shapeLayer.path = self.pathStart.cgPath
            self.shapeLayer.removeAllAnimations()
        }
    
        shapeLayer.add(animation, forKey: nil)
        CATransaction.commit()
        
    }
 
    


}

