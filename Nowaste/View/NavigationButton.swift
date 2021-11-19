//
//  NavigationButton.swift
//  Nowaste
//
//  Created by Gilles Sagot on 18/11/2021.
//

import UIKit

class NavigationButton: UIButton {
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(frame: CGRect, image: String) {
        self.init(frame: frame)
        
        self.frame = frame
        self.setBackgroundImage(UIImage(systemName: image), for: .normal)
        self.layer.cornerRadius = self.frame.width / 2
        self.tintColor = .init(white: 1.0, alpha: 1.0)
    }



}
