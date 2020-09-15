//
//  NavigationFactory.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

protocol NavigationFactory {
    func makePlansNavigationView() -> UINavigationController
    func makeProjectsNavigationView() -> UINavigationController
}
