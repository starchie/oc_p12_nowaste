//
//  SegmentedControl.swift
//  Nowaste
//
//  Created by Gilles Sagot on 25/11/2021.
//

import UIKit


class SegmentedControl: UIView {
    
    var items = [UIButton]()
    var hStack = UIStackView()
    var button0 = UIButton()
    var button1 = UIButton()
    var selectedSegmentIndex:Int = 0 {
        didSet{
            updateView()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        button0.setImage(UIImage(named: "star_0"), for: .normal)
        button0.imageView?.contentMode = .scaleAspectFit
        button0.imageView?.animationImages = animatedImages(for: "star")
        button0.imageView?.animationDuration = 1.4
        button0.imageView?.animationRepeatCount = .zero
        button0.backgroundColor = .clear
        
        button1.setImage(UIImage(named: "form_5"), for: .normal)
        button1.imageView?.contentMode = .scaleAspectFit
        button1.imageView?.animationImages = animatedImages(for: "form")
        button1.imageView?.animationDuration = 1.4
        button1.imageView?.animationRepeatCount = .zero
        button1.backgroundColor = .clear
        
        hStack.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.addArrangedSubview(button0)
        hStack.addArrangedSubview(button1)
        self.addSubview(hStack)
        
        updateView()
        
        
    }
    
    func updateView (){
        switch selectedSegmentIndex {
            
        case 0:
            button0.imageView?.startAnimating()
            button0.alpha = 1.0
            button1.imageView?.stopAnimating()
            button1.alpha = 0.3
            
        case 1:
            button0.imageView?.stopAnimating()
            button0.alpha = 0.3
            button1.imageView?.startAnimating()
            button1.alpha = 1.0
         
            
        default:
            button1.imageView?.stopAnimating()
            button0.imageView?.stopAnimating()
            
        

          
        }
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
    
   
    

    
    
}
