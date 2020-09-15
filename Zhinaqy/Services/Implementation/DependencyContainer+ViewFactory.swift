//
//  DependencyContainer+ViewFactory.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


extension DependencyContainer: ViewFactory {
    
    func makeProjectsView() -> ProjectsView {
        return ProjectsView(viewModel: self.makeProjectsViewModel())
    }
    
    func makeNewProjectView(with project: Project?,
                            type: NewProjectState) -> NewProjectView {
        return NewProjectView(viewModel: self.makeNewProjectViewModel(with: project),
                              type: type)
    }
    
    
    func makeNewTaskView(with task: Task?,
                         type: NewTaskState,
                         project: Project) -> NewTaskView {
        return NewTaskView(type: type,
                           viewModel: self.makeNewTaskViewModel(task: task,
                                                                project: project))
    }
    
    
    func makeRootView() -> UITabBarController {
        return RootView(views: [ self.makePlansNavigationView(),
                                 self.makeProjectsNavigationView() ])
    }
    
    
    func makePlansView() -> PlansView {
        return PlansView(viewModel: self.makePlansViewModel())
    }
    
}

