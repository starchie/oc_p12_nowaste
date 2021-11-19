//
//  NavigationController.swift
//  Reciplease
//
//  Created by Gilles Sagot on 24/08/2021.
//

import UIKit


class NavigationController: UINavigationController {
    
    var currentState:states = .intro {
        didSet{
            update()
        }
    }
    
    enum states {
        case intro, login, register, map, list, profile, detail
    }
    
    var topBarHeight:CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        let window = scene.windows.first
        let frameWindow = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let frameNavigationBar = self.navigationBar.frame.height
        return frameWindow + frameNavigationBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(" ", terminator: Array(repeating: "\n", count: 10).joined())
        print("Scroll up for Firebase log")
        print("Nowaste v0.1")
        
        self.navigationBar.tintColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let vc  = IntroController()
        self.pushViewController(vc, animated: true)
        self.view.backgroundColor = .clear
       
    }
    
    func update(){
        switch currentState {
        case .intro:
            print("intro")
            self.navigationBar.isHidden = true
            
        case .login:
            print("login")
            self.navigationBar.isHidden = false
            
        case .register:
            print("register")
            self.navigationBar.isHidden = false
            
        case .map:
            print("map")
            self.navigationBar.isHidden = false
       
        case .list:
            print("list")
            self.navigationBar.isHidden = false
            
        case .profile:
            print("profile")
            self.navigationBar.isHidden = false
            
        case .detail:
            print("detail")
            self.navigationBar.isHidden = false

        }
        
    }
    
    override func viewWillLayoutSubviews() {
        print (self.viewControllers.count)
    }
    

    


}

