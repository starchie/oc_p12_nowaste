//
//  LogInController.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 19/10/2021.

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

class LogInController: UIViewController {
    
    var logInView:LogInView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = navigationController as! NavigationController
        nc.currentState = .login
        
        logInView = LogInView(inView: self.view)
        self.view.addSubview(logInView)
        
        logInView.login.addTarget(self, action:#selector(login), for: .touchUpInside)
        logInView.noAccount.addTarget(self, action:#selector(goRegister), for: .touchUpInside)
        
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: -  ACTIONS
    
    func goMap() {
        // CHECK THE UID EXIST...
        guard FirebaseService.shared.currentUser?.uid != nil
        else { self.presentUIAlertController(title: "Erreur", message: "Vous n'êtes pas connecté"); return}
        
        // ...BEFORE USE IT TO GET THE PROFILE
        FirebaseService.shared.querryProfile(filter: FirebaseService.shared.currentUser!.uid) {success, error in
            if success {
                // CONTINUE TO MAP
                let vc = MapController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // ERROR
                self.presentUIAlertController(title: "Erreur", message: "Impossible de charger vos informations")
            }
            
        }
        
    }
    
    // LOGIN USER
    @objc func login () {
        
        FirebaseService.shared.login(mail: logInView.mail.textView.text!, pwd: logInView.password.textView.text!) { success, error in
            if success {
                self.goMap()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
 
        }
        
         
    }
    
    @objc func goRegister() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
