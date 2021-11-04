//
//  HorizontalScrollView.swift
//  Testing
//
//  Created by Gilles Sagot on 24/10/2021.
//

import UIKit

class HorizontalScrollView: UIView {
    
    var itemDescription:UILabel!
    var itemTitle:UILabel!
    var itemDate:UILabel!
    var itemImage:UIImageView!
    var slice:UIView!
    var stack:UIStackView!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        itemDate = UILabel()
        self.addSubview(itemDate)
        itemDate.font = UIFont(name: "Helvetica", size: 12)
        itemDate.text = "11.09.2021 à 12h00 30s"
        itemDate.textAlignment = .center
        itemDate.sizeToFit()
        itemDate.center = CGPoint(x: frame.midX - 20, y: 30)
        
        itemTitle = UILabel()
        self.addSubview(itemTitle)
        itemTitle.numberOfLines = 3
        itemTitle.lineBreakMode = .byTruncatingTail
        itemTitle.font = UIFont(name: "Helvetica-Bold", size: 18)
        itemTitle.text = "Titre qui peut être un peu long"
        itemTitle.textAlignment = .center
        itemTitle.sizeToFit()
        itemTitle.center.x = frame.midX - 20
        itemTitle.center.y = itemDate.center.y + 20
        
    }
    

}
