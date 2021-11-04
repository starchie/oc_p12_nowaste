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
        
        createShape()
        shapeLayer.path = self.path.cgPath
        
        itemImage = UIImageView()
        self.addSubview(itemImage)
        itemImage.frame = CGRect(x: 0, y: 0 , width: frame.width, height: frame.width / 1.3333)
        itemImage.layer.mask = shapeLayer
        itemImage.backgroundColor = .clear
        itemImage.contentMode = .scaleAspectFill
        itemImage.clipsToBounds = true
        
        
        itemTitle = UILabel()
        itemTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        itemTitle.text = "Titre qui peut être un peu long"
        itemTitle.textAlignment = .center
        itemTitle.numberOfLines = 0
        itemTitle.sizeToFit()
        
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
    }
    
    
    
    
    
    
    func createShape() {
        path = UIBezierPath()
  
        path.move(to: CGPoint(x: 0.0, y: 251) )
        path.addCurve(to: CGPoint(x: self.frame.width, y: 251),
                      controlPoint1: CGPoint(x: self.frame.width / 4, y: 201),
                      controlPoint2:CGPoint(x: self.frame.width - self.frame.width / 4, y: 201))
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
    }

}
