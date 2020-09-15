//
//  DependencyContainer+NavigationFactory.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

extension DependencyContainer: NavigationFactory {
    
    func makePlansNavigationView() -> UINavigationController {
        return PlansNavigator(factory: self)
    }
    
    
    func makeProjectsNavigationView() -> UINavigationController {
        return ProjectsNavigator(factory: self)
    }
    
}
