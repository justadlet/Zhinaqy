//
//  PlansNavigator.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class PlansNavigator: UINavigationController, Navigator {
    
    let factory: ViewFactory & ViewModelFactory
    
    enum Destination {
        case newTask(task: Task?, type: NewTaskState)
    }
    
    init(factory: DependencyContainer) {
        self.factory = factory
        super.init(rootViewController: factory.makePlansView())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func navigate(to destination: Destination) {
        self.pushViewController(self.makeDestination(to: destination), animated: true)
    }
    
    
    func makeDestination(to destination: Destination) -> UIViewController {
        switch destination {
        case .newTask(let task, let type):
            return factory.makeNewTaskView(with: task, type: type)
        }
    }
}
