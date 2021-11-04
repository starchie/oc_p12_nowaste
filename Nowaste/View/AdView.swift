//
//  DetailView.swift
//  Testing
//
//  Created by Gilles Sagot on 25/10/2021.
//

import UIKit

class AdView: UIView {
    
    var adTitle:UILabel!
    var adDescription:UILabel!
    var adImage:UIImageView!
    var adDate:UILabel!
    var adButton:UIButton!
    
    var stack:UIStackView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adImage = UIImageView()
        self.addSubview(adImage)
        adImage.frame = CGRect(x: 10, y: 0 , width: frame.width - 20, height: frame.width / 1.33)
        adImage.image = UIImage(systemName: "photo")
        adImage.tintColor = .gray
        adImage.backgroundColor = .lightGray
        adImage.contentMode = .scaleAspectFill
        adImage.layer.cornerRadius = 10
        adImage.clipsToBounds = true
        
        adTitle = UILabel()
        adTitle.font = UIFont(name: "Helvetica-Bold", size: 18)
        adTitle.text = "Titre qui peut être un peu long"
        adTitle.sizeToFit()
        
        adButton = UIButton()
        adButton.frame = CGRect(x: 0, y: 0, width: 400, height: 50)
        adButton.backgroundColor = UIColor(red: 85/255, green: 85/255, blue: 192/255, alpha: 1.0)
        adButton.setTitle("Send ad", for: .normal)
        adButton.setTitleColor(.white, for: .normal)
        
        adDescription = UILabel()
        adDescription.numberOfLines = 6
        adDescription.text = """
            C’est lui aussi qui était à la base du dernier processeur, le sphéro. Un processeur ayant une architecture en forme de sphère et capable de traiter les informations  à une vitesse jamais atteinte.
            """
        adDescription.sizeToFit()
        
        stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = true
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
        stack.alignment = .fill
        stack.contentMode = .top
        
        stack.distribution = .fillProportionally
        self.addSubview(stack)
        stack.addArrangedSubview(adTitle)
        stack.addArrangedSubview(adDescription)
        stack.addArrangedSubview(adButton)
        //stack.backgroundColor = .cyan
        stack.frame = CGRect(x: 0,
                             y: adImage.frame.maxY,
                             width: frame.width,
                             height: frame.height - adImage.frame.maxY - 80)
    }

}
