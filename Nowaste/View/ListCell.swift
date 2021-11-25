//
//  LIstCell.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.

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

class ListCell: UITableViewCell {
    
    var circleView: UIView!
    var imageProfile: UIImageView!
    var cellTitle: UILabel!
    var distanceView: UILabel!
    
    var totalSize:CGFloat = 0
    
    var activeAds:Int = 0
    var buttons = [UIButton]()
    

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor =  UIColor(red: 37/255, green: 47/255, blue: 66/255, alpha: 1.0)
        
        circleView = UIView()
        circleView.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
        circleView.backgroundColor = .white
        circleView.layer.cornerRadius = 20
        self.addSubview(circleView)
        
        imageProfile = UIImageView()
        imageProfile.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
        imageProfile.backgroundColor = .white
        imageProfile.image = UIImage(named: "Carrots")
        imageProfile.layer.cornerRadius = 20
        imageProfile.clipsToBounds = true
        imageProfile.layer.borderWidth = 3
        imageProfile.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        self.addSubview(imageProfile)
        
        cellTitle = UILabel()
        cellTitle.font = UIFont(name: "Helvetica-Bold", size: 20)
        cellTitle.text = "Title here "
        cellTitle.textColor = .white
        cellTitle.sizeToFit()
        let currentWidthTitle = cellTitle.frame.width
        
        cellTitle.frame = CGRect(x: circleView.frame.maxX + 10,
                                 y: circleView.frame.midY - 15,
                                 width: currentWidthTitle,
                                 height: 30)
        
        self.addSubview(cellTitle)
        
        distanceView = UILabel()
        
        distanceView.font = UIFont(name: "Helvetica", size: 16)
        distanceView.text = "à 44000 m"
        distanceView.textColor = .white
        distanceView.sizeToFit()
        let distanceWidthTitle = distanceView.frame.width
        distanceView.frame = CGRect(x: cellTitle.frame.maxX + 10,
                                 y: cellTitle.frame.maxY - 30,
                                 width: distanceWidthTitle,
                                 height: 30)

        
        self.addSubview(distanceView)
        
        
        
    
    }
    
    // MARK: - LAYOUT PROFILE LINE
    
    func layoutFirstLine (image:UIImage ,title:String, distance:String){
        imageProfile.image = image
        
        cellTitle.text = title
        cellTitle.sizeToFit()
        let currentWidthTitle = cellTitle.frame.width
        cellTitle.frame = CGRect(x: imageProfile.frame.maxX + 10,
                                 y: imageProfile.frame.midY - 15,
                                 width: currentWidthTitle,
                                 height: 30)
        
        distanceView.text = distance
        distanceView.sizeToFit()
        let distanceWidthTitle = distanceView.frame.width
        distanceView.frame = CGRect(x: cellTitle.frame.maxX + 10,
                                 y: cellTitle.frame.maxY - 30,
                                 width: distanceWidthTitle,
                                 height: 30)
        
        
    }
    
    // MARK: - ANIMATION
    
    func anim(refSize:CGFloat) {
        
        var delay = 0.0
        // CHANGE LEFT SHAPE HEIGHT TO FIT THE VIEW CELL
        if refSize == 60 {
            self.circleView.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
        }else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: { self.circleView.frame = CGRect(x: 20, y: 10, width: 40, height: refSize - 20) }, completion: nil)
            
        }
        // ANIM VIEW FROM RIGHT TO LEFT
        for button in buttons {
            Timer.scheduledTimer(withTimeInterval: 0.3 * delay, repeats: false) { (timer) in
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                    button.center.x -= self.frame.width }, completion: nil)
            }
            delay += 1.0
            
        }
    
    }
    
    
    func showSubView() {
        for i in 0..<buttons.count {
            self.addSubview(buttons[i])
            totalSize = buttons[i].frame.maxY
        }
    }
    
    
    func removeView() {
        for viewWithTag in self.subviews {
            if viewWithTag.tag >= 100{
                viewWithTag.removeFromSuperview()
            }
        }
    }
    
    
}
