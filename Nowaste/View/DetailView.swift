//
//  DetailView.swift
//  Testing
//
//  Created by Gilles Sagot on 25/10/2021.
//

import UIKit

class DetailView: UIView {
    
    var itemDescription:UILabel!
    var itemTitle:UILabel!

    var itemDate:UILabel!
    var itemImage:UIImageView!
    var vStack:UIStackView!
    var hStack:UIStackView!
    var contactButton:UIButton!

    
    var countView: UILabel!
    var countImageView: UIButton!
    
    var path: UIBezierPath!
    let shapeLayer = CAShapeLayer()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0)
        
        itemTitle = UILabel()
        itemTitle.frame = CGRect(x:0, y: 0, width: self.frame.width - 60, height: 100)
        itemTitle.numberOfLines = 0
        itemTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        itemTitle.text = "🍎Titre qui peut être un peu long"
        itemTitle.textAlignment = .left
        itemTitle.center.x = frame.midX - 20
        itemTitle.center.y = 100
        itemTitle.textColor = .white
        self.addSubview(itemTitle)
        
        itemImage = UIImageView()
        self.addSubview(itemImage)
        
        itemDescription = UILabel()
        countView = UILabel()
        countImageView = UIButton(type: .system)
        hStack = UIStackView()
        
        vStack = UIStackView()
        self.addSubview(vStack)
        
        contactButton = UIButton()
        self.addSubview(contactButton)
        
  
    }
    
    func updateViews(){
    
        itemImage.frame = CGRect(x: 0, y: itemTitle.frame.maxY, width: frame.width, height: (frame.width) / 1.3333)
        itemImage.backgroundColor = .blue
        itemImage.contentMode = .scaleAspectFill
        itemImage.clipsToBounds = true
        
        
        
        itemDescription.numberOfLines = 0
        itemDescription.text = """
            C’est lui aussi qui était à la base du dernier processeur, le sphéro. Un processeur ayant une architecture ...
                        C’est lui aussi qui était à la base du dernier processeur, le sphéro. Un processeur ayant une architecture ...
                        C’est lui aussi qui était à la base du dernier processeur, le sphéro. Un processeur ayant une architecture ...
                                    C’est lui aussi qui était à la base du dernier processeur, le sphéro. Un processeur ayant une architecture ...
            """
        itemDescription.sizeToFit()
        itemDescription.textColor = .white
        
        
        countImageView.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
        countImageView.tintColor = .white

        countView.text =  "+ 123"
        countView.textAlignment = .center
        countView.textColor = .white
        
       
        hStack.axis = .horizontal
        hStack.addArrangedSubview(countImageView)
        hStack.addArrangedSubview(countView)
        
        contactButton.setBackgroundImage(UIImage(systemName: "mail"),for: .normal)
        contactButton.tintColor = .white
        contactButton.frame = CGRect(x: self.frame.midX - 30, y: self.frame.maxY - 60, width: 60, height: 40)
        
        vStack.translatesAutoresizingMaskIntoConstraints = true
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.axis = .vertical
        vStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
        vStack.alignment = .center
        vStack.distribution = .fillProportionally
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(itemDescription)
        vStack.frame = CGRect(x: 0,
                              y: itemImage.frame.maxY,
                              width: self.frame.width,
                              height: contactButton.frame.minY - itemImage.frame.maxY)
        
        
    }
    

}





/*
 itemImage = UIImageView()
 self.addSubview(itemImage)
 itemImage.frame = CGRect(x: 0, y: itemTitle.frame.maxY + 10 , width: frame.width - 20, height: frame.width / 1.3333)
 itemImage.backgroundColor = .blue
 itemImage.contentMode = .scaleAspectFill
 itemImage.clipsToBounds = true
 
 
 itemDescription = UILabel()
 itemDescription.numberOfLines = 0
 itemDescription.text = """
     C’est lui aussi qui était à la base du dernier processeur, le sphéro. Un processeur ayant une architecture ...
     """
 itemDescription.sizeToFit()
 
 countImageView = UIButton(type: .system)
 countImageView.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
 countImageView.tintColor = .black
 
 
 countView = UILabel()
 countView.text =  "+ 123"
 countView.textAlignment = .center
 
 hStack = UIStackView()
 hStack.axis = .horizontal
 hStack.addArrangedSubview(countImageView)
 hStack.addArrangedSubview(countView)
 
 vStack = UIStackView()
 vStack.translatesAutoresizingMaskIntoConstraints = true
 vStack.isLayoutMarginsRelativeArrangement = true
 vStack.axis = .vertical
 vStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 20)
 vStack.alignment = .center
 vStack.distribution = .equalSpacing
 self.addSubview(vStack)
 vStack.addArrangedSubview(itemTitle)
 vStack.addArrangedSubview(hStack)
 vStack.addArrangedSubview(itemDescription)
 vStack.frame = CGRect(x: 0,
                      y: itemImage.frame.maxY - 20,
                      width: frame.width,
                      height: frame.height - itemImage.frame.maxY - 200)
 
 
 
 contactButton = UIButton()
 contactButton.setBackgroundImage(UIImage(systemName: "mail"),for: .normal)
 contactButton.tintColor = .black
 contactButton.frame = CGRect(x: self.frame.midX - 30, y: vStack.frame.maxY + 5, width: 60, height: 40)
 self.addSubview(contactButton)
 */
