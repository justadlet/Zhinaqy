//
//  UINavigationController.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/12/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    
    ///Make navigation bar transparent and set system background colors
    func transparentNavigation() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = Color.systemBackground
        self.navigationBar.barTintColor = Color.systemBackground
    }
    
}
