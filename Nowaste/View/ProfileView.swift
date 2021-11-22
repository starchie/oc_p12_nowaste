//
//  ProfileView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 16/11/2021.

/// Copyright (c) 2021 Starchie
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

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
