//
//  ProjectViewModel.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import CoreData

class ProjectViewModel {
    
    private let coreDataManager: CoreDataManager
    let project: Project
    
    lazy var fetchController: NSFetchedResultsController<Task> = {
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true),
            NSSortDescriptor(key: "start", ascending: true)
        ]
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: self.coreDataManager.context,
                                          sectionNameKeyPath: "date",
                                          cacheName: nil)
    }()
    
    var segments: [String]{
        if self.project.type == "goal" {
            return ["Habits", "Tasks"]
        } else {
            return ["Pending", "In progress", "Done", "Events"]
        }
    }
    var predicate: NSPredicate {
        if self.project.type == "goal" {
            return NSPredicate(format: "project == %@ AND type == %@",
                               project,
                               self.selectedIndex.value == 0 ? "habit" : "task")
        } else {
            if selectedIndex.value == 0 {
                return NSPredicate(format: "project == %@ AND type == %@ AND step == %@",
                                   project, "task", "pending")
            } else if selectedIndex.value == 1 {
                return NSPredicate(format: "project == %@ AND type == %@ AND step == %@",
                                   project, "task", "inProgress")
            } else if selectedIndex.value == 2 {
                return NSPredicate(format: "project == %@ AND type == %@ AND step == %@",
                                  project, "task", "done")
            } else {
                return NSPredicate(format: "project == %@ AND type == %@",
                                   project, "event")
            }
        }
    }
    
    let selectedIndex: Bindable<Int> = Bindable(0)
    
    init(project: Project, coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.project = project
    }
    
    
}


//MARK:- DataFetchable
extension ProjectViewModel: DataFetchable {
    
    func fetchData(completion: @escaping() -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.fetchController.fetchRequest.predicate = self.predicate
            
            do {
                try self.fetchController.performFetch()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
}



//MARK:- TaskModifiable
extension ProjectViewModel: TaskModifiable {
    
    func increment(_ task: Task) {
        if task.type == "habit" && task.progress < task.count {
            coreDataManager.update(entity: task,
                                   content: ["progress": task.progress + 1]) { _ in }
        } else if task.type == "task" {
            coreDataManager.update(entity: task,
                                   content: ["step": task.nextStep]) { _ in }
        }
    }
    
    
    func decrement(_ task: Task) {
        if task.type == "habit" && task.progress > 0 {
            coreDataManager.update(entity: task,
                                   content: ["progress": task.progress - 1]) { _ in }
        } else if task.type == "task" {
            coreDataManager.update(entity: task,
                                   content: ["step": task.prevStep]) { _ in }
        }
    }

    
    func deleteAll(_ task: Task) {
        coreDataManager.delete(name: "Task",
                               predicate: NSPredicate(format: "id == %@",
                                                          task.id! as NSUUID)) { _ in }
    }
    
    func delete(_ task: Task) {
        coreDataManager.delete(entity: task) { _ in }
    }
    
    
}
