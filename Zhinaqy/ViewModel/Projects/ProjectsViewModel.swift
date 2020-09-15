//
//  ProjectsViewModel.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import CoreData


class ProjectsViewModel {
    
    private let coreDataManager: CoreDataManager
    lazy var fetchController: NSFetchedResultsController<Project> = {
        let request = NSFetchRequest<Project>(entityName: "Project")
        request.sortDescriptors = [ NSSortDescriptor(key: "name", ascending: true) ]
        request.fetchBatchSize = 20
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: self.coreDataManager.context,
                                          sectionNameKeyPath: "type",
                                          cacheName: "type")
    }()
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    
    func delete(_ project: Project) {
        coreDataManager.delete(entity: project) { _ in }
    }
}


//MARK:- DataFetchable
extension ProjectsViewModel: DataFetchable {
    
    func fetchData(completion: @escaping () -> ()) {
        do {
            try self.fetchController.performFetch()
            completion()
        } catch {
            completion()
        }
    }
    
}
