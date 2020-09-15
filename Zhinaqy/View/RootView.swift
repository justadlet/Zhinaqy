//
//  RootView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class RootView: UITabBarController {
    
    init(views: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = views
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
