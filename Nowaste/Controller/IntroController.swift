//
//  IntroController.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 18/10/2021.
//

import UIKit



class IntroController: UIViewController {
    
    var titleLabel = UITextField()
    var register = UIButton()
    var logIn = UIButton()
    //var introView: IntroView!

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(red: 8/255, green: 16/255, blue: 76/255, alpha: 1.0)
        print (FirebaseService.shared.storage)
        //introView = IntroView(frame: view.frame)
        //view.addSubview(introView)
        
        titleLabel = UITextField()
        titleLabel.font = UIFont(name: "ArialRoundedMTBold", size: 60)
        titleLabel.textColor = .white
        titleLabel.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        titleLabel.text = "n🍎 waste."
        titleLabel.textAlignment = .center
        titleLabel.center = view.center
        
        
        view.addSubview(titleLabel)
        
        titleLabel.text = ""
        var charIndex = 0.0
        let titleText = "no waste."
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        register.frame = CGRect(x: 30, y: view.frame.maxY - 50, width: view.frame.width - 60, height: 50)
        register.layer.cornerRadius = register.frame.height / 2
        register.setTitle("Register", for: .normal)
        register.setTitleColor(.white, for: .normal)
        register.backgroundColor =  UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0)
        register.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        view.addSubview(register)
        
        logIn.frame = register.frame.offsetBy(dx: 0, dy: -55)
        logIn.layer.cornerRadius = logIn.frame.height / 2
        logIn.setTitle("Log In", for: .normal)
        logIn.setTitleColor(.white, for: .normal)
        logIn.backgroundColor =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        logIn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        view.addSubview(logIn)
        
        register.addTarget(self, action:#selector(goRegister), for: .touchUpInside)
        logIn.addTarget(self, action:#selector(goLogIn), for: .touchUpInside)
        
        /*
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            if FirebaseService.shared.currentUser != nil {
                let vc = ListController()
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
         */
        
           
    }
    
    @objc func goLogIn() {
        let vc = LogInController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func goRegister() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    



}
