//
//  StarsView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 02/11/2021.
//

import UIKit

class StarView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear

        for i in 0..<5 {
            let star = UIImageView()
            star.frame = CGRect(x: 15 * i, y: 0, width: 10, height: 10)
            star.image = UIImage(systemName: "star.fill")
            star.tintColor = .gray
            self.addSubview(star)
        }
  
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        

        
       
    }

}
