//
//  NavigationController.swift
//  Reciplease
//
//  Created by Gilles Sagot on 24/08/2021.

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


class NavigationController: UINavigationController {
    
    var currentState:states = .intro {
        didSet{
            update()
        }
    }
    
    enum states {
        case intro, login, register, map, list, ad, profile, detail
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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.navigationBar.standardAppearance = appearance;
        self.navigationBar.scrollEdgeAppearance = self.navigationBar.standardAppearance
        self.navigationBar.isTranslucent = true
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

        case .ad:
            print("ad")
            self.navigationBar.isHidden = false
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        print (self.viewControllers.count)
    }
    

    


}

