//
//  LogInController.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 19/10/2021.
//

import UIKit

class LogInController: UIViewController {
    
    var logInView:LogInView!
    
    var topBarHeight:CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationController?.navigationBar.frame.height ?? 0
        return frameWindow + frameNavigationBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInView = LogInView(inView: self.view)
        
        logInView.center = CGPoint(x: self.view.center.x,
                                   y: self.view.center.y)
        
        self.view.addSubview(logInView)
        
        logInView.login.addTarget(self, action:#selector(login), for: .touchUpInside)
        
    }
    
    //MARK: -  ALERT CONTROLLER
    
    private func presentUIAlertController(title:String, message:String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: -  ACTION
    
    func goMap() {
        let vc = MapController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @objc func login () {
        FirebaseService.shared.login(mail: logInView.mail.text!, pwd: logInView.password.text!) { success, error in
            if success {
                self.goMap()
            }else{
                self.presentUIAlertController(title: "Enregistrement", message: error!)
            }
 
        }
    }
    
    
}
