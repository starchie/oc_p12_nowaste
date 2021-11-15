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
    var anim = UIImageView()
    var onion = UIImageView()
    var tomatoe = UIImageView()
    var turnip = UIImageView()
    var carrot = UIImageView()
    var vegetables = [UIImageView]()
    //var introView: IntroView!

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        anim.startAnimating()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        print (FirebaseService.shared.storage)
        //introView = IntroView(frame: view.frame)
        //view.addSubview(introView)
        anim.frame = CGRect(x: 0, y: view.frame.width/2 - 30, width: view.frame.width, height: view.frame.width )
        view.addSubview(anim)

        anim.alpha = 1.0
        anim.animationImages = animatedImages(for: "boom")
        anim.animationDuration = 1.4
        anim.animationRepeatCount = 1
        anim.image = anim.animationImages?.first
        
        tomatoe.image = UIImage(named: "tomatoe")
        tomatoe.frame = CGRect(x: view.frame.midX, y: view.frame.midY - 100, width: 100, height: 100)
        tomatoe.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        
        onion.image = UIImage(named: "onion")
        onion.frame = CGRect(x: 100, y: 130, width: 100, height: 100)
        onion.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        
        turnip.image = UIImage(named: "turnip")
        turnip.frame = CGRect(x: view.frame.maxX - 140, y: view.frame.midY, width: 100, height: 100)
        turnip.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        
        carrot.image = UIImage(named: "carrot")
        carrot.frame = CGRect(x: 40, y: view.frame.midY + 50, width: 100, height: 100)
        carrot.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
        
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
        titleLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 60)
        
        titleLabel.text = "no waste."
        titleLabel.sizeToFit()
        titleLabel.textAlignment = .left
        titleLabel.center = view.center
        
        view.addSubview(titleLabel)
        
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
    
    // MARK: - UTILS
    
    func animatedImages(for name: String) -> [UIImage] {
        print("blabla")
        var i = 0
        var images = [UIImage]()
        
        while let image = UIImage(named: "\(name)_\(i)") {
            print (i)
            images.append(image)
            i += 1
        }
        return images
    }
    



}
