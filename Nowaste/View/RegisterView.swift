//
//  SignInView.swift
//  Barter
//
//  Created by Gilles Sagot on 10/10/2021.

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

class RegisterView: UIView {
    
    var imageProfile: UIImageView!
    
    var userName: FormView!
    var mail: FormView!
    var password: FormView!
  
    var number: FormView!
    var street: FormView!
    var code: FormView!
    var city: FormView!
    
    var register: UIButton!
    
    var accountExist: UIButton!
    
    var vstack: UIStackView!
 

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        
        imageProfile = UIImageView(image: UIImage(systemName: "person.fill"))
        imageProfile.frame = CGRect(x: 0, y: 10, width: 100, height: 100)
        imageProfile.layer.cornerRadius = 50
        imageProfile.backgroundColor = .init(white: 1, alpha: 0.2)
        imageProfile.tintColor = .white
        imageProfile.clipsToBounds = true
        imageProfile.layer.borderWidth = 4
        imageProfile.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        imageProfile.center.x = self.center.x
        self.addSubview(imageProfile)
        
        userName = FormView(frame: CGRect(x: 0, y: imageProfile.frame.maxY, width: 200, height: 30),text: "Surnom")
        mail = FormView(frame: CGRect(x: 0, y: imageProfile.frame.maxY, width: 200, height: 30),text: "Mail")
        password = FormView(frame: CGRect(x: 0, y: imageProfile.frame.maxY, width: 200, height: 30),text: "Mot De Passe")
        street = FormView(frame: CGRect(x: 0, y: imageProfile.frame.maxY, width: 200, height: 30),text: "Adresse")
        code = FormView(frame: CGRect(x: 0, y: imageProfile.frame.maxY, width: 200, height: 30),text: "Code")
        city = FormView(frame: CGRect(x: 0, y: imageProfile.frame.maxY, width: 200, height: 30),text: "Ville")
    
        
        register = UIButton()
        register.setTitle("Inscription", for: .normal)
        register.frame = CGRect(x: 20,
                                y: self.bounds.maxY - 120,
                                width: self.bounds.width - 40,
                                height: 30)
        register.setTitleColor(.white, for: .normal)
        
        accountExist = UIButton()
        accountExist.setTitle("Déjà inscrit ? Connectez-vous", for: .normal)
        accountExist.titleLabel?.adjustsFontSizeToFitWidth = true
        accountExist.setTitleColor(.white, for: .normal)
        accountExist.frame = CGRect(x: 20,
                                    y: self.bounds.maxY - 60,
                                    width: self.bounds.width - 40,
                                    height: 30)
        
        let range = NSRange(location:15,length:14) // specific location. This means "range" handle 1 character at location 2

        let attributedString = NSMutableAttributedString(string: "Déjà inscrit ? Connectez-vous", attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 12)!])
      
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name:"Helvetica-Bold", size: 12)!, range: range)
        accountExist.titleLabel?.attributedText = attributedString
    
        self.addSubview(register)
        self.addSubview(accountExist)
        
    
        
        vstack = UIStackView()
        vstack.axis = .vertical
        vstack.alignment = .fill
        vstack.distribution = .fillEqually
        vstack.frame = CGRect(x: 20, y: imageProfile.frame.maxY, width: self.bounds.width - 40, height: register.frame.minY - imageProfile.frame.maxY)
        vstack.addArrangedSubview(userName)
        vstack.addArrangedSubview(mail)
        vstack.addArrangedSubview(password)
        vstack.addArrangedSubview(street)
        vstack.addArrangedSubview(code)
        vstack.addArrangedSubview(city)
 
        self.addSubview(vstack)
         
    }
    
    
    
}
