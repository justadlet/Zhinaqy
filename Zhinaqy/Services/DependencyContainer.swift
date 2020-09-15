//
//  DependencyContainer.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


final class DependencyContainer {
    
    ///Singleton element
    static let shared = DependencyContainer()
    
    ///Avoiding multiple instances
    private init() {}
    
    
    //MARK: Variables
    lazy var coreDataManager = CoreDataManager()
}


