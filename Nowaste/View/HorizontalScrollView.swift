//
//  HorizontalScrollView.swift
//  Testing
//
//  Created by Gilles Sagot on 24/10/2021.
//

import UIKit

class HorizontalScrollView: UIView {
    
    var itemTitle:UILabel!
    var itemDate:UILabel!

    
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
        itemDate.center = CGPoint(x: frame.midX - 20, y: 70)
        itemDate.textColor = .white
        
        
        itemTitle = UILabel()
        self.addSubview(itemTitle)
        
        itemTitle.frame = CGRect(x:0, y: 0, width: self.frame.width - 100, height: 100)
        itemTitle.numberOfLines = 0
        itemTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        itemTitle.text = "Titre qui peut être un peu long"
        itemTitle.textAlignment = .center
        itemTitle.center.x = frame.midX - 20
        itemTitle.center.y = 100
        itemTitle.textColor = .white
        

        
        
    }
    

}
