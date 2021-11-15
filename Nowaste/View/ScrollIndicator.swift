//
//  ScrollIndicator.swift
//  Nowaste
//
//  Created by Gilles Sagot on 15/11/2021.
//

import UIKit


class ScrollIndicator: UIView {
    
    let replicator = CAReplicatorLayer()
    let dot = CALayer()
    let dotLength: CGFloat = 6.0
    let dotOffset: CGFloat = 20.0
    var number: Int = 3 {
        didSet {
            createDots()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        replicator.frame = self.bounds
        self.layer.addSublayer(replicator)
        
        replicator.addSublayer(dot)

        dot.backgroundColor = UIColor(white: 1, alpha: 0.5).cgColor
        dot.cornerRadius = 3.0
        
        createDots()
       
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    func createDots (){
        
        dot.frame = CGRect(x: replicator.frame.size.width / 2
                           + ( (CGFloat(number) * ( dotOffset) / 2 ) - dotLength ),
                           y: replicator.position.y,
                           width: dotLength,
                           height: dotLength)
        
        replicator.instanceCount = number

        replicator.instanceTransform = CATransform3DMakeTranslation(-dotOffset, 0.0, 0.0)
       
        
        
    }

}
