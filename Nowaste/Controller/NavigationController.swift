//
//  NavigationController.swift
//  Reciplease
//
//  Created by Gilles Sagot on 24/08/2021.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(" ", terminator: Array(repeating: "\n", count: 10).joined())
        print("Scroll up for Firebase log")
        print("🍏Nowaste v0.1")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let vc  = IntroController()
        self.pushViewController(vc, animated: true)
        self.view.backgroundColor = .clear
       
    }
    


}
