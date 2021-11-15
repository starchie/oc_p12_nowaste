//
//  SearchView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.
//

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
        shapeLayer.fillColor =  UIColor(white: 1.0, alpha: 0.3).cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        goButton = UIButton()
        self.addSubview(goButton)
        goButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)        
        goButton.tintColor = .init(white: 1.0, alpha: 1.0)
        goButton.frame = CGRect(x: frame.maxX - 90, y: 120, width: 20, height: 20)
        
        searchText = UITextField()
        searchText.placeholder = "Légume ou fruit "
        self.addSubview(searchText)
        searchText.frame = CGRect(x: 70, y: 110, width: frame.width - 170, height: 40)
        searchText.font = UIFont(name: "Helvetica-Bold", size: 21)
        //searchText.backgroundColor = .blue
        searchText.textColor = UIColor.white
        searchText.textAlignment = .center
        
        line = UIView()
        line.frame = CGRect(x: 70, y: 150, width: frame.width - 170, height: 1)
        line.backgroundColor = .white
        self.addSubview(line)
        
        
        slider = UISlider()
        self.addSubview(slider)
        slider.tintColor = .white
        slider.value = 1
        slider.frame = CGRect(x: 40, y: 80, width: frame.width - 100, height: 20)
        
        searchDistanceLabel = UILabel()
        self.addSubview(searchDistanceLabel)
        searchDistanceLabel.textColor = .white
        searchDistanceLabel.font = UIFont(name: "Helvetica-Bold", size: 12)
        searchDistanceLabel.text = "10 km"
        searchDistanceLabel.frame = CGRect(x: slider.frame.maxX + 10,
                                           y: 80,
                                           width: 100,
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
