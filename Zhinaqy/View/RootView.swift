//
//  RootView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class RootView: UITabBarController {
    
    let views: [UIViewController]
    
    init(views: [UIViewController]) {
        self.views = views
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        for subView in views {
            self.addChild(subView)
        }
    }
}
