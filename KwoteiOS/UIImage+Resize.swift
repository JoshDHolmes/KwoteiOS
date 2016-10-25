//
//  UIImage+Resize.swift
//  KwoteiOS
//
//  Created by Joshua Holmes on 25/10/16.
//  Copyright © 2016 Joshua Holmes. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public func resize(height: CGFloat) -> UIImage? {
        let scale = height / self.size.height
        let newWidth = self.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: height))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
