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

class AdView: UIView {
    
    var infoLabel:UILabel!
    var adTitle:UITextView!
    var adDescription:UITextView!
    var adImage:UIImageView!
    var adDate:UILabel!
    var adButton:UIButton!


    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        infoLabel = UILabel()
        infoLabel.text = "Quelque chose à partager ? Remplissez les champs suivants"
        infoLabel.adjustsFontSizeToFitWidth = true
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .white
        infoLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        infoLabel.frame = CGRect(x: 10, y: 0 , width: frame.width - 20, height: 60)
        self.addSubview(infoLabel)
        
        adImage = UIImageView()
        self.addSubview(adImage)
        adImage.frame = CGRect(x: 0, y: infoLabel.frame.maxY + 10 , width: frame.width, height: frame.height / 3)
        adImage.image = UIImage(systemName: "photo")
        adImage.tintColor = .init(white: 1, alpha: 0.2)
        adImage.backgroundColor = UIColor.init(white: 1.0, alpha: 0.05)
        adImage.contentMode = .center
        adImage.clipsToBounds = true
        
        adTitle = UITextView()
        self.addSubview(adTitle)
        adTitle.autocorrectionType = .no
        adTitle.autoresizingMask = .flexibleTopMargin
        adTitle.spellCheckingType = .no
        adTitle.frame = CGRect(x: 0, y: adImage.frame.maxY + 10, width: frame.width, height: frame.height / 8)
        adTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        adTitle.textColor = .init(white: 1, alpha: 0.2)
        adTitle.backgroundColor = UIColor.init(white: 1.0, alpha: 0.05)
    
        adTitle.text = "le titre de votre annonce"
    
        adButton = UIButton()
        self.addSubview(adButton)
        adButton.frame = CGRect(x: 60,
                                y: frame.maxY - frame.height / 4,
                                width: frame.width - 120,
                                height: frame.height / 8)
        adButton.backgroundColor = UIColor.clear
        adButton.setTitle("Envoyer", for: .normal)
        adButton.setTitleColor(.white, for: .normal)
        
        adDescription = UITextView()
        self.addSubview(adDescription)

        adDescription.font = UIFont(name: "Helvetica-Bold", size: 16)
        adDescription.autocorrectionType = .no
        adDescription.spellCheckingType = .no
        adDescription.autoresizingMask = .flexibleBottomMargin
        adDescription.textColor = .init(white: 1, alpha: 0.2)
        adDescription.backgroundColor = UIColor.init(white: 1.0, alpha: 0.05)
        adDescription.text = "Écrivez une description de votre annonce ici..."
        adDescription.frame = CGRect(x: 0,
                                     y: (adTitle.frame.maxY + 10),
                                     width: frame.width ,
                                     height: adButton.frame.minY - (adTitle.frame.maxY + 20) )
      
        
    }

}
