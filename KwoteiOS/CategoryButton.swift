//
//  CategoryButton.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 27/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import UIKit

class CategoryButton: UIButton {
    let width = 100
    let height = 80
    let borderWidth = 1
    let borderColor = UIColor.darkGray
    public var pressableButton: UIButton!
    
    var icon: UILabel?
    var title: UILabel?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.icon?.textColor = UIColor.white
                self.title?.textColor = UIColor.white
                self.backgroundColor = UIColor.customGreen
            } else {
                self.icon?.textColor = UIColor.black
                self.title?.textColor = UIColor.black
                self.backgroundColor = UIColor.white
            }
        }
    }
    
    convenience init(title: String, icon: String) {
        self.init()
        
        self.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        self.backgroundColor = UIColor.white
        self.titleLabel?.text = ""
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = CGFloat(self.borderWidth)
        
        self.pressableButton = UIButton(frame: self.frame)
        self.pressableButton.backgroundColor = UIColor.clear
        self.pressableButton.titleLabel?.text = ""
        
        let iconLabel = UILabel()
        iconLabel.font = UIFont(name: "FontAwesome", size: 30)
        iconLabel.frame = CGRect(x: 0, y: 15, width: self.width, height: 30)
        iconLabel.text = icon
        iconLabel.textAlignment = .center
        self.icon = iconLabel
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "AlexandriaFLF", size: 20)
        titleLabel.frame = CGRect(x: 0, y: 50, width: self.width, height: 20)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        self.title = titleLabel
        
        self.addSubview(iconLabel)
        self.addSubview(titleLabel)
        self.addSubview(self.pressableButton)
        self.bringSubview(toFront: self.pressableButton)
    }
    
    func labelPressed() {
        print("Label pressed")
        self.sendActions(for: .touchUpInside)
    }
}
