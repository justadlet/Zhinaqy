//
//  PlansNavigator.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class PlansNavigator: UINavigationController, Navigator {
    
    private let factory: ViewFactory & ViewModelFactory
    
    
    enum Destination {
        case newTask(task: Task?, type: NewTaskState, project: Project)
        case project(project: Project)
    }
    

    init(factory: DependencyContainer) {
        self.factory = factory
        super.init(rootViewController: factory.makePlansView())
        self.tabBarItem = UITabBarItem(title: "Plans",
                                       image: UIImage(named: "plans"),
                                       tag: 0)
        self.view.backgroundColor = Color.systemBackground
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func navigate(to destination: Destination) {
        self.pushViewController(self.makeDestination(to: destination), animated: true)
    }
    
    
    private func makeDestination(to destination: Destination) -> UIViewController {
        switch destination {
        case .newTask(let task,
                      let type,
                      let project):
            return factory.makeNewTaskView(with: task,
                                           type: type,
                                           project: project)
        case .project(let project):
            return factory.makeProjectView(with: project)
        }
    }
}
