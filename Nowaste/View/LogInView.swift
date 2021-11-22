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

class LogInView: UIView {
    
    var mail: UITextField!
    var password: UITextField!
    var login: UIButton!

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(inView: UIView) {
        let rect = CGRect(x: 0, y: 0, width: inView.frame.width, height: inView.frame.height)
        self.init(frame: rect)
        
        let color =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        
        self.frame = rect
        self.backgroundColor = color
        
        
        mail = UITextField()
        mail.backgroundColor = .white
        mail.layer.cornerRadius = 25
        mail.placeholder = "Email"
        mail.text = "lucile@nowatse.com"
        mail.autocapitalizationType = .none
        mail.frame = CGRect(x: 0, y: 0, width: rect.width - 20, height: 50)
        mail.center = CGPoint(x: self.center.x, y: self.center.y - 160)
        mail.textAlignment = .center
 
        password = UITextField()
        password.backgroundColor = .white
        password.layer.cornerRadius = 25
        password.placeholder = "Password"
        password.text = "123456"
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.frame = mail.frame.offsetBy(dx: 0, dy: 55)
        password.textAlignment = .center
        
        login = UIButton()
        login.setTitle("Login", for: .normal)
        login.frame = password.frame.offsetBy(dx: 0, dy: 55)

        self.addSubview(mail)
        self.addSubview(password)
        self.addSubview(login)
 
    }
    
    
    
}
