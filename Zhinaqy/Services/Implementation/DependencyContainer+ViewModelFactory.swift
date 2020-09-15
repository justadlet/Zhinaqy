//
//  DependencyContainer+ViewModelFactory.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation


extension DependencyContainer: ViewModelFactory {
    
    
    func makeProjectViewModel(with project: Project) -> ProjectViewModel {
        return ProjectViewModel(project: project,
                                coreDataManager: self.coreDataManager)
    }
    
    
    func makeProjectsViewModel() -> ProjectsViewModel {
        return ProjectsViewModel(coreDataManager: self.coreDataManager)
    }
    
    func makeNewProjectViewModel(with project: Project?) -> NewProjectViewModel {
        return NewProjectViewModel(project: project,
                                   coreDataManager: self.coreDataManager)
    }
    
    
    func makePlansViewModel() -> PlansViewModel {
        return PlansViewModel(with: self.coreDataManager)
    }
    
    
    func makeNewTaskViewModel(task: Task?,
                              project: Project) -> NewTaskViewModel {
        return NewTaskViewModel(coreDataManager: self.coreDataManager,
                                task: task,
                                project: project)
    }
    
    func makeProjectView(with project: Project) -> ProjectView {
        return ProjectView(type: project.type == "goal" ? .goal : .project,
                           viewModel: self.makeProjectViewModel(with: project))
    }
    
}
