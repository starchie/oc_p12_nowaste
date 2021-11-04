//
//  SearchView.swift
//  Nowaste
//
//  Created by Gilles Sagot on 31/10/2021.
//

import UIKit

class SearchView: UIView {
    
    var searchButton:UIButton!
    var searchText:UITextView!
    var line: UIView!
    var slider: UISlider!
    var searchDistanceLabel: UILabel!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: 100)
        self.backgroundColor =  UIColor(red: 85/255,green: 85/255,blue: 192/255,alpha: 1.0)
        
        searchButton = UIButton()
        self.addSubview(searchButton)
        searchButton.setBackgroundImage(UIImage(systemName: "magnifyingglass.circle"), for: .normal)        
        searchButton.tintColor = .init(white: 1.0, alpha: 1.0)
        searchButton.frame = CGRect(x: frame.maxX - 60, y: 40, width: 40, height: 40)
        
        searchText = UITextView()
        self.addSubview(searchText)
        searchText.frame = CGRect(x: 40, y: 40, width: frame.width - 100, height: 40)
        searchText.font = UIFont(name: "Helvetica-Bold", size: 21)
        searchText.backgroundColor = .clear
        searchText.textColor = UIColor.white
        searchText.textAlignment = .center
        
        line = UIView()
        self.addSubview(line)
        line.frame = CGRect(x: 40, y: 81, width: frame.width - 100, height: 1)
        line.backgroundColor = .white
        
        slider = UISlider()
        self.addSubview(slider)
        slider.tintColor = .white
        slider.value = 1
        slider.frame = CGRect(x: 40, y: searchText.frame.minY - 40, width: 100, height: 30)
        
        searchDistanceLabel = UILabel()
        self.addSubview(searchDistanceLabel)
        searchDistanceLabel.textColor = .white
        searchDistanceLabel.text = "10 km"
        searchDistanceLabel.frame = CGRect(x: slider.frame.maxX + 10,
                                           y: slider.frame.minY,
                                           width: 100,
                                           height: 30)
       
    }
}
