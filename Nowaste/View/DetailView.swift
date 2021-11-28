//
//  DetailView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 25/10/2021.

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

class DetailView: UIView {
    
    
    var itemDescription:UITextView!
    var itemTitle:UILabel!
    var itemDate:UILabel!
    var itemImage:UIImageView!
    var vStack:UIStackView!
    var hStack:UIStackView!
    var contactButton:UIButton!
    var card:CardView!
    var countView: UILabel!
    var countImageView: UIButton!
    var bg: UIView!
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        itemTitle = UILabel()
        itemImage = UIImageView()
        countView = UILabel()
        hStack = UIStackView()
        bg = UIView()
        itemDescription = UITextView()
        contactButton = UIButton()
        
        itemTitle.numberOfLines = 0
        itemTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        itemTitle.adjustsFontSizeToFitWidth = true
        itemTitle.frame = CGRect(x: 10, y: 0, width: self.frame.width - 20, height: self.frame.height / 8)
        itemTitle.textAlignment = .left
        itemTitle.textColor = .white
        self.addSubview(itemTitle)
 
        itemImage.frame = CGRect(x: 0, y: itemTitle.frame.maxY + 5, width: self.frame.width, height: self.frame.height / 4)
        itemImage.contentMode = .scaleAspectFill
        itemImage.clipsToBounds = true
        self.addSubview(itemImage)
        
        countView.textAlignment = .center
        countView.textColor = .white
        
        countImageView = UIButton(type: .system)
        countImageView.setImage(UIImage(systemName: "person.3.fill"), for: .normal)
        countImageView.tintColor = .white
      
        hStack.axis = .horizontal
        hStack.addArrangedSubview(countImageView)
        hStack.addArrangedSubview(countView)
        hStack.alignment = .center
        hStack.frame = CGRect(x: self.frame.width / 2 - (self.frame.width / 8), y: itemImage.frame.maxY + 5.0, width: self.frame.width / 4, height: self.frame.height / 16)
        hStack.sizeToFit()
        self.addSubview(hStack)
        
        bg.backgroundColor = UIColor(red: 81/255, green: 150/255, blue: 98/255, alpha: 1.0)
        bg.frame = CGRect(x: 0, y: self.frame.height - self.frame.height / 4, width: self.frame.width, height: self.frame.height / 4)
        bg.layer.cornerRadius = 20
        self.addSubview(bg)
        
        itemDescription.backgroundColor = .clear
        itemDescription.frame = CGRect(x: 0, y: hStack.frame.maxY, width: self.frame.width, height: bg.frame.minY - hStack.frame.maxY)
        itemDescription.textColor = .white
        itemDescription.font = UIFont(name: "Helvetica", size: 18)
        self.addSubview(itemDescription)
        
        card = CardView(frame: CGRect(x: bg.frame.midX - (bg.frame.height / 2),
                                      y: 10,
                                      width: bg.frame.height,
                                      height: bg.frame.height / 2) )
        
     
        contactButton.frame = CGRect(x: bg.frame.midX - 20,
                                     y: card.frame.maxY + 10,
                                     width: 40,
                                     height: 30)
        
        contactButton.setBackgroundImage(UIImage(systemName: "mail"),for: .normal)
        contactButton.tintColor = .white
        
        bg.addSubview(card)
        bg.addSubview(contactButton)
        
        
    }
    


}

