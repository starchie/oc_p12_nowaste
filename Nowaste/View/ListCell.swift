//
//  LIstCell.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.
//

import UIKit

class ListCell: UITableViewCell {
    
    var circleView: UIView!
    var cellTitle: UILabel!
    var distanceView: UILabel!
    
    var totalSize:CGFloat = 0
    
    var activeAds:Int = 0
    var list = [UIButton]()
    

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor(red: 8/255, green: 16/255, blue: 76/255, alpha: 1.0)
        
        circleView = UIView()
        circleView.frame = CGRect(x: 4, y: 4, width: 40, height: 40)
        circleView.backgroundColor = UIColor(red: 80/255, green: 140/255, blue: 80/255, alpha: 1.0)
        circleView.layer.cornerRadius = 20
        self.addSubview(circleView)
        
        cellTitle = UILabel()
        cellTitle.font = UIFont(name: "Helvetica-Bold", size: 20)
        cellTitle.text = "Title here"
        cellTitle.textColor = .white
        cellTitle.sizeToFit()
        cellTitle.center = CGPoint(x: circleView.frame.width + cellTitle.frame.midX + 20,
                                   y: circleView.frame.midY)
        self.addSubview(cellTitle)
        
        distanceView = UILabel()
        distanceView.font = UIFont(name: "Helvetica", size: 16)
        distanceView.text = "à 44000 m"
        distanceView.textColor = .white
        distanceView.sizeToFit()
        distanceView.center = CGPoint(x: cellTitle.frame.maxX + 10,
                                      y: circleView.frame.midY + 2)
        
        self.addSubview(distanceView)
        
        
        
    
    }
    
    func anim(h:CGFloat) {
        
        var delay = 0.0

        if circleView.frame.height >= 50 {
            self.circleView.frame = CGRect(x: 4, y: 4, width: 40, height: h - 5)
        }else {
            //self.circleView.frame = CGRect(x: 4, y: 4, width: 40, height: h - 5)
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: { self.circleView.frame = CGRect(x: 4, y: 4, width: 40, height: h - 5) }, completion: nil)
            
        }
        
        for item in list {
            Timer.scheduledTimer(withTimeInterval: 0.3 * delay, repeats: false) { (timer) in
                UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveLinear], animations: {
                    item.center.x -= self.frame.width }, completion: nil)
            }
            delay += 1.0
            
        }
    
    }
    
    
    
    
    func showSubView() {
        for i in 0..<list.count {
            self.addSubview(list[i])
            totalSize = list[i].frame.maxY
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
