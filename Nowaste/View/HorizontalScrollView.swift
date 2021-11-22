//
//  HorizontalScrollView.swift
//  Testing
//
//  Created by Gilles Sagot on 24/10/2021.

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

class HorizontalScrollView: UIView {
    
    var itemTitle:UILabel!
    var itemDate:UILabel!

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
    
        itemDate = UILabel()
        self.addSubview(itemDate)
        
        itemDate.font = UIFont(name: "Helvetica", size: 12)
        itemDate.text = "11.09.2021 à 12h00 30s"
        itemDate.textAlignment = .center
        itemDate.sizeToFit()
        itemDate.center = CGPoint(x: frame.midX - 20, y: 70)
        itemDate.textColor = .white
        
        
        itemTitle = UILabel()
        self.addSubview(itemTitle)
        
        itemTitle.frame = CGRect(x:0, y: 0, width: self.frame.width - 100, height: 100)
        itemTitle.numberOfLines = 0
        itemTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        itemTitle.text = "Titre qui peut être un peu long"
        itemTitle.textAlignment = .center
        itemTitle.center.x = frame.midX - 20
        itemTitle.center.y = 100
        itemTitle.textColor = .white
        

        
        
    }
    

}
