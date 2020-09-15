//
//  UIColor.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

extension UIColor {
    
    /**
     Initilize color from rgb with parameters
     -  Parameters:
        - rgb: RGB integer
        - a: alpha value
     */
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: a
        )
    }
    
    static let main: UIColor = UIColor(red: 0.941, green: 0.769, blue: 0.106, alpha: 1.0)
    
}
