//
//  ProjectsNavigator.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit

class ProjectsNavigator: UINavigationController, Navigator {
    
    private let factory: ViewFactory & ViewModelFactory
    
    
    enum Destination {
        case newProject(project: Project?, type: NewProjectState)
        case project(project: Project)
        case newTask(task: Task?, type: NewTaskState, project: Project)
    }
    
    
    init(factory: DependencyContainer) {
        self.factory = factory
        super.init(rootViewController: factory.makeProjectsView())
        self.tabBarItem = UITabBarItem(title: "Projects",
                                       image: UIImage(named: "projects"),
                                       tag: 1)
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
        case .newProject(let project,
                         let type):
            return factory.makeNewProjectView(with: project,
                                              type: type)
        case .project(let project):
            return factory.makeProjectView(with: project)
        case .newTask(let task,
                      let type,
                      let project):
            return factory.makeNewTaskView(with: task,
                                           type: type,
                                           project: project)
        }
    }
}
