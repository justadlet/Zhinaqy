//
//  PlansViewModel.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import CoreData

class PlansViewModel {
    
    private let coreDataManager: CoreDataManager
    lazy var fetchController: NSFetchedResultsController<Task> = {
        
        let request = NSFetchRequest<Task>(entityName: "Task")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true),
            NSSortDescriptor(key: "start", ascending: true)
        ]
        request.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: self.coreDataManager.context,
                                          sectionNameKeyPath: "date",
                                          cacheName: nil)
    }()
    
    let currentMonth: Bindable<Date> = Bindable(Date().start(of: .month))
    let currentDay: Bindable<Date> = Bindable(Date().start(of: .day))
    
    
    init(with coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    func changeMonth(by value: Int, completion: @escaping() -> ()) {
        currentDay.value = currentMonth.value.increment(by: value, .month).start(of: .month)
        currentMonth.value = currentMonth.value.increment(by: value, .month)
        fetchData(completion: completion)
    }
    
}


//MARK:- DataFetchable
extension PlansViewModel: DataFetchable {
    
    func fetchData(completion: @escaping() -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                self.fetchController.fetchRequest.predicate =
                    NSPredicate(format: "date BETWEEN { %@, %@ }",
                                self.currentMonth.value.start(of: .day) as NSDate,
                                self.currentMonth.value.increment(.month).increment(by: -1, .day) as NSDate)
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
extension PlansViewModel: TaskModifiable {
    
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
