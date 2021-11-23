//
//  IntroController.swift
//  iOSFundamental
//
//  Created by Gilles Sagot on 18/10/2021.

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



class IntroController: UIViewController {
    
    var titleLabel = UITextField()
    var register = UIButton()
    var logIn = UIButton()
    var boom = UIImageView()
    var onion = UIImageView()
    var tomatoe = UIImageView()
    var turnip = UIImageView()
    var carrot = UIImageView()
    var vegetables = [UIImageView]()
    //var introView: IntroView!

    
    override func viewWillAppear(_ animated: Bool) {
        let nc = navigationController as? NavigationController
        nc?.currentState = .intro
        playAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        //let bgimage = UIImageView(image: UIImage(named: "vegetables"))
        //bgimage.frame = view.frame
        //bgimage.contentMode = .scaleAspectFill
        //bgimage.alpha = 1.0
        //view.addSubview(bgimage)
        boom.frame = CGRect(x: 0, y: view.frame.width/2 - 30, width: view.frame.width, height: view.frame.width )
        view.addSubview(boom)

        boom.alpha = 1.0
        boom.animationImages = animatedImages(for: "boom")
        boom.animationDuration = 1.4
        boom.animationRepeatCount = 1
        boom.image = boom.animationImages?.first
        
        tomatoe.image = UIImage(named: "tomatoe")
        tomatoe.frame = CGRect(x: view.frame.midX, y: view.frame.midY - 100, width: 100, height: 100)
        
        onion.image = UIImage(named: "onion")
        onion.frame = CGRect(x: 100, y: 130, width: 100, height: 100)
        
        turnip.image = UIImage(named: "turnip")
        turnip.frame = CGRect(x: view.frame.maxX - 140, y: view.frame.midY, width: 100, height: 100)
        
        carrot.image = UIImage(named: "carrot")
        carrot.frame = CGRect(x: 40, y: view.frame.midY + 50, width: 100, height: 100)
        
        vegetables.append(turnip)
        vegetables.append(onion)
        vegetables.append(tomatoe)
        vegetables.append(carrot)
        
        for vegetable in vegetables {
            view.addSubview(vegetable)
        }
        
        titleLabel = UITextField()
        titleLabel.font = UIFont(name: "Chalkduster", size: 30)
        titleLabel.textColor = .white
        titleLabel.text = "no waste."
        titleLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 60)
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .left
        titleLabel.center = view.center
        view.addSubview(titleLabel)
        
        register.frame = CGRect(x: 30, y: view.frame.maxY - 70, width: view.frame.width - 60, height: 50)
        register.setTitle("Inscription", for: .normal)
        register.setTitleColor(.white, for: .normal)
       // register.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        view.addSubview(register)
        
        logIn.frame = register.frame.offsetBy(dx: 0, dy: -55)
        logIn.setTitle("Connexion", for: .normal)
        logIn.setTitleColor(.white, for: .normal)
       // logIn.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        view.addSubview(logIn)
        
        register.addTarget(self, action:#selector(goRegister), for: .touchUpInside)
        logIn.addTarget(self, action:#selector(goLogIn), for: .touchUpInside)
        
    }
    
    @objc func goLogIn() {
        let vc = LogInController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goRegister() {
        let vc = RegisterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UTILS
    
    func animatedImages(for name: String) -> [UIImage] {
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)_\(i)") {
            images.append(image)
            i += 1
        }
        return images
    }
    
    func playAnimations() {
        boom.startAnimating()
        
        for vegetable in vegetables {
            vegetable.alpha = 0
        }
        
        titleLabel.text = ""
        var charIndex = 0.0
        var vegetIndex = 0.0
        let titleText = "no waste."
        
        Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { (timer) in
            for letter in titleText {
                Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                    self.titleLabel.text?.append(letter)
                }
                charIndex += 1
            }
            for vegetable in self.vegetables {
                Timer.scheduledTimer(withTimeInterval: 0.2 * vegetIndex, repeats: false) { (timer) in
                    UIView.animate(withDuration: 0.4, delay: 0, options: [], animations: {
                        vegetable.alpha = 1.0
                    }, completion: nil)
                }
                vegetIndex += 1
            }
        }
        
        // DISABLE ANIMATIONS FOR UI TEST TO AVOID LONG 'WAIT FOR APP TO IDLE'
        if (ProcessInfo.processInfo.environment["UITEST_DISABLE_ANIMATIONS"] == "YES") {
            UIView.setAnimationsEnabled(false)
        }
       
        // turnip
        UIView.animate(withDuration: 60, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.vegetables[0].transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.vegetables[0].transform = CGAffineTransform(translationX: -100, y: 40)
        }, completion: nil)
        // onion
        UIView.animate(withDuration: 80, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.vegetables[1].transform = CGAffineTransform(rotationAngle: .pi)
            self.vegetables[1].transform = CGAffineTransform(translationX: 100, y: 20)
        }, completion: nil)
        // tomatoe
        UIView.animate(withDuration: 40, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.vegetables[2].transform = CGAffineTransform(rotationAngle: .pi / 3)
            self.vegetables[2].transform = CGAffineTransform(translationX: -100, y: -40)
        }, completion: nil)
        // carrot
        UIView.animate(withDuration: 40, delay: 0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.vegetables[3].transform = CGAffineTransform(rotationAngle: .pi / 4)
            self.vegetables[3].transform = CGAffineTransform(translationX: 40, y: 40)
            
        }, completion: nil)
        
    }
    



}
