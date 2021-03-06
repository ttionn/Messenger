//
//  UIColor+RGB.swift
//  Messenger
//
//  Created by Matt Tian on 7/9/17.
//  Copyright © 2017 Bizersoft. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
