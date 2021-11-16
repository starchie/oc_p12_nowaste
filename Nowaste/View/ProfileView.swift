//
//  ProfileView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 16/11/2021.
//

import UIKit

class ProfileView: UIView {
    
    var imageProfile: UIImageView!
    var userName: UILabel!
    var line: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    
        imageProfile = UIImageView()
        imageProfile.image = UIImage(systemName: "person.circle.fill")
        imageProfile.frame = CGRect(x: 2.5, y: 2.5, width: frame.height - 5, height: frame.height - 5)
        imageProfile.layer.cornerRadius = 50
        
        
        userName = UILabel()
        userName.text = "user name"
        userName.font = UIFont(name: "Helvetica-Bold", size: 21)
        userName.textColor = .white
        userName.frame = CGRect(x: imageProfile.frame.maxX + 10, y: imageProfile.frame.midY - 15, width: 300, height: 30)
        
        line = UIView()
        line.frame = CGRect(x: 0, y: frame.height - 2, width: frame.width - 20, height: 2)
        line.backgroundColor = .white
        
        self.addSubview(imageProfile)
        self.addSubview(userName)
        //self.addSubview(line)
        
 
        
        
        

    }
    
  
    

}
