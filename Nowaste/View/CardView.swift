//
//  CardView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 21/11/2021.
//

import UIKit

class CardView: UIView {
    
    var vStack = UIStackView()
    var hStack = UIStackView()
    var imageProfile = UIImageView()
    var nameProfile = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageProfile.backgroundColor = .clear
        imageProfile.tintColor = .white
        imageProfile.image = UIImage(systemName: "person.circle.fill")
        imageProfile.contentMode = .scaleAspectFit
        imageProfile.clipsToBounds = true
        
        nameProfile.backgroundColor = .clear
        nameProfile.adjustsFontSizeToFitWidth = true
        nameProfile.text = "pseudo"
        nameProfile.textColor = .white
        hStack.frame = CGRect(x: 0, y: 0, width: frame.width , height: frame.height )
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .fillProportionally
        hStack.addArrangedSubview(imageProfile)
        hStack.addArrangedSubview(nameProfile)
        
    
        self.addSubview(hStack)
        
    }
    
    override func layoutSubviews() {
        imageProfile.layer.cornerRadius = imageProfile.frame.width/2
    }
    
    
  

}
