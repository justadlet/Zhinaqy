//
//  CoreDataManager.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    
    
    // MARK: Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Zhinaqy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    //MARK: Main Context
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    
    // MARK: Save main context
    func saveContext (completion: @escaping(CoreDataResult) -> Void) {
        if self.context.hasChanges {
            do {
                try self.context.save()
                DispatchQueue.main.async {
                    completion(.success)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error(type: .saveFailed))
                }
            }
        }
    }
    
    
}




//MARK:- EntityModifiable
extension CoreDataManager: EntityModifiable {


    func create(name: String,
                content: [String: Any],
                completion: @escaping(CoreDataResult) -> ()) {
        
        self.context.perform {
            let entity = NSEntityDescription.insertNewObject(forEntityName: name,
                                                             into: self.context)
            for (key, value) in content {
                entity.setValue(value, forKey: key)
            }
            
            self.saveContext(completion: completion)
        }
    }
    
    
    func update(entity: NSManagedObject,
                content: [String: Any],
                completion: @escaping(CoreDataResult) -> ()) {
        self.context.perform {
            for (key, value) in content {
                entity.setValue(value, forKey: key)
            }
            
            self.saveContext(completion: completion)
        }
    }
    
    
    func delete(entity: NSManagedObject,
                completion: @escaping(CoreDataResult) -> ()) {
        self.context.perform {
            
            self.context.delete(entity)
            
            self.saveContext(completion: completion)
        }
    }
    
}




//MARK:- Contextable
extension CoreDataManager: Contextable  {
    
    
    func newPrivateContext() -> NSManagedObjectContext {
        
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self.context
        
        return privateContext
    }
    
    
    func saveContext(_ privateContext: NSManagedObjectContext,
                     completion: @escaping (CoreDataResult) -> ()) {
        if privateContext.hasChanges {
            do {
                try privateContext.save()
                self.reset(privateContext)
                DispatchQueue.main.async {
                    completion(.success)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.error(type: .saveFailed))
                }
            }
        }
    }
    
    
    func reset(_ privateContext: NSManagedObjectContext) {
        privateContext.reset()
    }
    
}




//MARK:- BatchRequestable
extension CoreDataManager: BatchRequestable {
    
    
    func execute(in privateContext: NSManagedObjectContext,
                 with request: NSPersistentStoreRequest,
                 completion: @escaping (CoreDataResult) -> ()) {
        do {
            let result = try privateContext.execute(request) as? NSBatchDeleteResult
            
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes = [NSDeletedObjectsKey : objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [self.context])
            self.reset(privateContext)
            DispatchQueue.main.async {
                self.saveContext(completion: completion)
            }
        } catch {
            DispatchQueue.main.async {
                completion(.error(type: .saveFailed))
            }
        }
    }
    
    
    func create(name: String,
                content: [[String : Any]],
                completion: @escaping (CoreDataResult) -> ()) {
        
        let privateContext = newPrivateContext()
        
        privateContext.perform {
            content.forEach { (item) in
                let entity = NSEntityDescription.insertNewObject(forEntityName: name,
                                                                 into: privateContext)
                for (key, value) in item {
                    if let value = value as? NSManagedObject {
                        entity.setValue(privateContext.object(with: value.objectID),
                                        forKey: key)
                    } else {
                        entity.setValue(value, forKey: key)
                    }
                }
            }
            self.saveContext(privateContext) { (result) in
                switch result {
                case .success:
                    self.saveContext(completion: completion)
                default:
                    completion(result)
                }
            }
        }
    }
    
    
    func update(name: String,
                content: [String : Any],
                predicate: NSPredicate?,
                completion: @escaping (CoreDataResult) -> ()) {
        let privateContext = newPrivateContext()
        
        privateContext.perform {
            let batchUpdate = NSBatchUpdateRequest(entityName: name)
            batchUpdate.predicate = predicate
            batchUpdate.resultType = .updatedObjectIDsResultType
            batchUpdate.propertiesToUpdate = content
            
            self.execute(in: privateContext,
                         with: batchUpdate,
                         completion: completion)
        }
    }
    
    
    func delete(name: String,
                predicate: NSPredicate?,
                completion: @escaping (CoreDataResult) -> ()) {
        let privateContext = newPrivateContext()
        
        privateContext.perform {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            request.predicate = predicate
            let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
            batchDelete.resultType = .resultTypeObjectIDs
            
            self.execute(in: privateContext,
                         with: batchDelete,
                         completion: completion)
        }
    }
    
}
