//
//  IntroView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 03/11/2021.
//

import UIKit

class IntroView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layerPurple()
        layerPink()
        layerGreen()
        layerYellow()
        
        layerCircleOrange()
        layerCircleGreen()
        layerCirclePurple()
        
        
        for layer in self.layer.sublayers! {
            if layer.name == "yellow" {
                layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8)
            }
            
            if layer.name == "pink" {
                layer.transform = CATransform3DMakeScale(0.7, 0.7, 0.7)
            }
            
            if layer.name == "green" {
                layer.transform = CATransform3DMakeTranslation(-40, -10, 0)
            }
            
            if layer.name == "purple" {
                layer.transform = CATransform3DMakeTranslation( 0, -60, 0)
            }
   
        }
  
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func layerYellow() {
        // Initialize the path.
        
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 40, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 180, y:  160) )
        
        path.move(to: CGPoint(x: 140, y: self.frame.height - 100) )
        path.addLine(to: CGPoint(x: self.frame.width - 80, y:  220) )
        
        path.move(to: CGPoint(x: 220, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 0, y:  160) )
        
        shape.path = path.cgPath
        shape.lineCap = .round
        shape.lineWidth = 10
        shape.strokeColor = UIColor(red: 223/255, green: 165/255, blue: 66/255, alpha: 1.0).cgColor
        shape.name = "yellow"
        
        self.layer.addSublayer(shape)
     
        path.stroke()
        
 
    }
    
    func layerPink() {
        // Initialize the path.
        
        let shape = CAShapeLayer()
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x: 40, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 180, y:  160) )
        
        path.move(to: CGPoint(x: 140, y: self.frame.height - 100) )
        path.addLine(to: CGPoint(x: self.frame.width - 80, y:  220) )
        
        path.move(to: CGPoint(x: 220, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 0, y:  160) )
        
        shape.path = path.cgPath
        shape.lineCap = .round
        shape.lineWidth = 30
        shape.strokeColor = UIColor(red: 220/255, green: 82/255, blue: 150/255, alpha: 1.0).cgColor
        shape.name = "pink"
        self.layer.addSublayer(shape)
     
        path.stroke()
        
 
    }
    
    func layerGreen() {
        // Initialize the path.
        
        let shape = CAShapeLayer()
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x: 40, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 180, y:  160) )
        
        path.move(to: CGPoint(x: 140, y: self.frame.height - 100) )
        path.addLine(to: CGPoint(x: self.frame.width - 80, y:  220) )
        
        path.move(to: CGPoint(x: 220, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 0, y:  160) )
        
        shape.path = path.cgPath
        shape.lineCap = .round
        shape.lineWidth = 20
        shape.strokeColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0).cgColor
        shape.name = "green"
        self.layer.addSublayer(shape)
     
        path.stroke()
        
 
    }
    
    func layerPurple() {
        // Initialize the path.
        
        let shape = CAShapeLayer()
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x: 40, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 180, y:  160) )
        
        path.move(to: CGPoint(x: 140, y: self.frame.height - 100) )
        path.addLine(to: CGPoint(x: self.frame.width - 80, y:  220) )
        
        path.move(to: CGPoint(x: 220, y: self.frame.height - 160) )
        path.addLine(to: CGPoint(x: self.frame.width - 0, y:  160) )
        
        shape.path = path.cgPath
        shape.lineCap = .round
        shape.lineWidth = 20
        shape.strokeColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0).cgColor
        shape.name = "purple"
        self.layer.addSublayer(shape)
     
        path.stroke()

    }
    
    func layerCircleOrange() {
        
        let shape = CAShapeLayer()
        var path = UIBezierPath()
        
        path = UIBezierPath(ovalIn: CGRect(x: self.frame.midX - 20,
                                           y: self.frame.midY - 140,
                                           width: 30,
                                           height: 30) )
        
        shape.path = path.cgPath
        shape.fillColor =  UIColor(red: 223/255, green: 165/255, blue: 66/255, alpha: 1.0).cgColor
        self.layer.addSublayer(shape)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: 0, y: 0)
        animation.toValue = CGPoint(x: 30, y: 60)
        animation.autoreverses = true
        animation.duration = 5
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
     
        
        shape.add(animation, forKey: nil)
        
        
        
    }
    
    func layerCircleGreen() {
        
        let shape = CAShapeLayer()
        var path = UIBezierPath()
        
        path = UIBezierPath(ovalIn: CGRect(x: self.frame.midX - 20,
                                           y: self.frame.midY - 140,
                                           width: 20,
                                           height: 20) )
        
        shape.path = path.cgPath
        shape.fillColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0).cgColor
        self.layer.addSublayer(shape)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: -30, y: 60)
        animation.toValue = CGPoint(x: -40, y: 0)
        animation.autoreverses = true
        animation.duration = 5
        animation.repeatCount = .infinity
     
        
        shape.add(animation, forKey: nil)
        
        
        
    }
    
    func layerCirclePurple() {
        
        let shape = CAShapeLayer()
        var path = UIBezierPath()
        
        path = UIBezierPath(ovalIn: CGRect(x: self.frame.midX - 20,
                                           y: self.frame.midY - 140,
                                           width: 50,
                                           height: 50) )
        
        shape.path = path.cgPath
        shape.fillColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0).cgColor
        self.layer.addSublayer(shape)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: 150, y: 200)
        animation.toValue = CGPoint(x: 50, y: 220)
        animation.autoreverses = true
        animation.duration = 5
        animation.repeatCount = .infinity
     
        
        shape.add(animation, forKey: nil)
           
    }
    
 
    

}
