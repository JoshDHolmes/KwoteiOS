//
//  KwoteLabel.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 25/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import UIKit

class KwoteLabel: UILabel {
    var edgeInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    
    override public var intrinsicContentSize: CGSize {
        get {
            var intrinsicSuperViewContentSize = super.intrinsicContentSize
            intrinsicSuperViewContentSize.height += self.edgeInsets.top + self.edgeInsets.bottom
            intrinsicSuperViewContentSize.width += self.edgeInsets.left + self.edgeInsets.right
            return intrinsicSuperViewContentSize
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, self.edgeInsets))
    }
}
