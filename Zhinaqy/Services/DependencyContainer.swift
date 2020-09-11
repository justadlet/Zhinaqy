//
//  DependencyContainer.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class DependencyContainer {
    
    
    //MARK: Init
    //Singleton
    static let shared = DependencyContainer()
    
    //Avoiding multiple instances
    private init() {}
    
    
    //MARK: Variables
    lazy var coreDataManager = CoreDataManager()
}



extension DependencyContainer: ViewModelFactory {
    
    func makePlansViewModel() -> PlansViewModel {
        return PlansViewModel(with: self.coreDataManager)
    }
    
    
    func makeNewTaskViewModel(task: Task?) -> NewTaskViewModel {
        return NewTaskViewModel(coreDataManager: self.coreDataManager, task: task)
    }
    
    
}


extension DependencyContainer: ViewFactory {
    
    
    func makeNewTaskView(with task: Task?, type: NewTaskState) -> NewTaskView {
        return NewTaskView(type: type, viewModel: self.makeNewTaskViewModel(task: task))
    }
    
    
    func makeRootView() -> UITabBarController {
        return RootView(views: [self.makePlansNavigationView()])
    }
    
    func makePlansNavigationView() -> UINavigationController {
        return PlansNavigator(factory: self)
    }
    
    func makePlansView() -> PlansView {
        return PlansView(viewModel: self.makePlansViewModel())
    }
    
}
