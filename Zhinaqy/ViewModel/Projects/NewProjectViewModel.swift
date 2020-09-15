//
//  NewProjectViewModel.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

class NewProjectViewModel {
    
    private let coreDataManager: CoreDataManager
    let project: Project?
    
    let name: Bindable<String>
    let deadline: Bindable<Date>
    
    
    init(project: Project?,
         coreDataManager: CoreDataManager) {
        
        self.coreDataManager = coreDataManager
        self.project = project
        
        self.name = Bindable(project?.name ?? "")
        self.deadline = Bindable(project?.deadline ?? Date())
    }
    
    
    func save(type: NewProjectState, completion: @escaping(CoreDataResult) -> Void) {
        if name.value.count == 0 && name.value.count > 50 {
            completion(.wrongParameter(message: "Name must be between 1-50 characters"))
            return
        }
        
        if project?.type == "goal"
            && deadline.value <= Date().increment(.day)
            && deadline.value > Date().increment(.year) {
            completion(.wrongParameter(message: "Deadline must be between a day or a year from now"))
            return
        }
        
        var content: [String: Any] {
            switch type {
            case .project:
                return [ "name": name.value,
                         "type": "project" ]
            case .goal:
                return [ "name": name.value,
                         "deadline": deadline.value.start(of: .day),
                         "type": "goal" ]
            }
        }

        
        if let project = project {
            coreDataManager.update(entity: project,
                                   content: content,
                                   completion: completion)
        } else {
            coreDataManager.create(name: "Project",
                                   content: content,
                                   completion: completion)
        }
    }
}
