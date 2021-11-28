//
//  SignInView.swift
//  Nowaste
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
    
    var mail: FormView!
    var password: FormView!
    var login: UIButton!
    var noAccount: UIButton!

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(inView: UIView) {
        let rect = CGRect(x: 0, y: 0, width: inView.frame.width, height: inView.frame.height)
        self.init(frame: rect)
        
        let color =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        self.frame = rect
        self.backgroundColor = color
        
        
        mail = FormView(frame: CGRect(x: 20, y: self.bounds.midX - 50, width: self.bounds.width - 40, height: 50), text: "Email")
        mail.textView.text = "lulu@nowaste.com"
 
        password = FormView(frame: CGRect(x: 20, y: mail.frame.maxY, width: self.bounds.width - 40, height: 50), text: "Mot de Passe")
        password.textView.text = "123456"
        password.textView.isSecureTextEntry = true
        password.textView.autocapitalizationType = .none

        
        login = UIButton()
        login.setTitle("Connexion", for: .normal)
        login.frame = password.frame.offsetBy(dx: 0, dy: 55)
        
        noAccount = UIButton()
        noAccount.setTitle("Pas encore de compte nowaste ? Inscrivez-vous", for: .normal)
        noAccount.titleLabel?.adjustsFontSizeToFitWidth = true
        noAccount.setTitleColor(.white, for: .normal)
        noAccount.frame = CGRect(x: 20,
                                  y: rect.maxY - 60,
                                  width: rect.width - 40,
                                  height: 30)
        
        let range = NSRange(location:31,length:14) // specific location. This means "range" handle 1 character at location 2

        let attributedString = NSMutableAttributedString(string: "Pas encore de compte nowaste ? Inscrivez-vous", attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 18)!])
      
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name:"Helvetica-Bold", size: 18)!, range: range)
        noAccount.titleLabel?.attributedText = attributedString
        

        self.addSubview(mail)
        self.addSubview(password)
        self.addSubview(login)
        self.addSubview(noAccount)
 
    }
    
    
    
}
