//
//  FormView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 25/11/2021.
//

import UIKit

class FormView: UIView {
    
    var textView: UITextField!
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    convenience init(frame: CGRect, text:String) {
        self.init(frame:frame)
        self.backgroundColor = .clear
        
        textView = UITextField()
        textView.backgroundColor = .white
        textView.placeholder = text
        textView.autocapitalizationType = .none
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.frame = CGRect(x: 5, y: 5, width: self.bounds.width - 10, height: self.bounds.height - 10)
        textView.layer.cornerRadius = textView.frame.height / 2
        textView.textAlignment = .center
        
        self.addSubview(textView)
        
    }
    
    override func layoutSubviews() {
        textView.layer.cornerRadius = textView.frame.height / 2
        textView.frame = CGRect(x: 5, y: 5, width: self.bounds.width - 10, height: self.bounds.height - 10)
    }
    
}
