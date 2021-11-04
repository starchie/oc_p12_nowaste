//
//  LikesView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 02/11/2021.
//

import UIKit

class LikesView: UIView {
    
    var countView: UILabel!
    var countImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        countImageView = UIImageView()
        countImageView.frame = CGRect(x: self.frame.midX, y: self.frame.midY, width: 40, height: 40)
        countImageView.image = UIImage(systemName: "person.3.fill")
       // self.addSubview(countImageView)
        
        countView = UILabel()
        countView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        countView.text =  "1234566"
        countView.textAlignment = .center
        self.addSubview(countView)
        
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
 

}
