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
    
    var userName: UITextField!
    
    var mail: UITextField!
    var password: UITextField!
  
    var number: UITextField!
    var street: UITextField!
    var code: UITextField!
    var city: UITextField!
    
    var register: UIButton!

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(inView: UIView) {
        let rect = CGRect(x: 0, y: 0, width: inView.frame.width, height: inView.frame.height)
        self.init(frame: rect)
        self.frame = rect
        
        self.backgroundColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0)
        
        
        imageProfile = UIImageView(image: UIImage(systemName: "person.fill"))
        imageProfile.frame = CGRect(x: 0, y: 10, width: 100, height: 100)
        imageProfile.layer.cornerRadius = 50
        imageProfile.backgroundColor = .init(white: 1, alpha: 0.2)
        imageProfile.tintColor = .white
        imageProfile.clipsToBounds = true
        imageProfile.layer.borderWidth = 4
        imageProfile.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        imageProfile.center.x = self.center.x
        
        userName = UITextField()
        userName.backgroundColor = .white
        userName.layer.cornerRadius = 25
        userName.placeholder = "User Name"
        userName.autocapitalizationType = .none
        userName.frame = CGRect(x: 0, y: imageProfile.frame.maxY + 10, width: rect.width - 20, height: 50)
        userName.textAlignment = .center
        userName.center.x = self.center.x
        
        mail = UITextField()
        mail.backgroundColor = .white
        mail.layer.cornerRadius = 25
        mail.placeholder = "Email"
        mail.autocapitalizationType = .none
        mail.frame = userName.frame.offsetBy(dx: 0, dy: 55)
        mail.textAlignment = .center
 
        password = UITextField()
        password.backgroundColor = .white
        password.layer.cornerRadius = 25
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.frame = mail.frame.offsetBy(dx: 0, dy: 55)
        password.textAlignment = .center
        
        street = UITextField()
        street.backgroundColor = .white
        street.layer.cornerRadius = 25
        street.placeholder = "Street"
        street.autocapitalizationType = .none
        street.frame = password.frame.offsetBy(dx: 0, dy: 55)
        street.textAlignment = .center
        
        code = UITextField()
        code.backgroundColor = .white
        code.layer.cornerRadius = 25
        code.placeholder = "Code"
        code.autocapitalizationType = .none
        code.frame = street.frame.offsetBy(dx: 0, dy: 55)
        code.textAlignment = .center
        
        city = UITextField()
        city.backgroundColor = .white
        city.layer.cornerRadius = 25
        city.placeholder = "City"
        city.autocapitalizationType = .none
        city.frame = code.frame.offsetBy(dx: 0, dy: 55)
        city.textAlignment = .center
        
        register = UIButton()
        register.setTitle("Register", for: .normal)
        register.frame = city.frame.offsetBy(dx: 0, dy: 55)
        register.setTitleColor(.white, for: .normal)

        self.addSubview(imageProfile)
        self.addSubview(userName)
        self.addSubview(mail)
        self.addSubview(password)
        self.addSubview(street)
        self.addSubview(code)
        self.addSubview(city)
        self.addSubview(register)
  
        
 
    }
    
    
    
}
