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

    
    //MARK: View Context
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    
    // MARK: Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    //MARK: Create new object
    func create(name: String, content: [String: Any], completion: @escaping(Result<String>) -> Void) {
        self.context.perform {
            if let description = NSEntityDescription.entity(
                forEntityName: name,
                in: self.context) {
                
                let entity = NSManagedObject(
                    entity: description,
                    insertInto: self.context)
                
                for (key, value) in content {
                    entity.setValue(value, forKey: key)
                }
                do {
                    if self.context.hasChanges {
                        try self.context.save()
                    }
                    completion(.success(data: "Successfully created \(description.name!)"))
                } catch {
                    completion(.failure(message: "Failed to create \(description.name!)"))
                }
            }
        }
    }
    
    
    
    //MARK: Update existing entity
    func update(entity: NSManagedObject, content: [String: Any], completion: @escaping(Result<String>) -> Void) {
        self.context.perform {
            for (key, value) in content {
                entity.setValue(value, forKey: key)
            }
            do {
                if self.context.hasChanges {
                    try self.context.save()
                }
                completion(.success(data: "Successfully updated \(entity.entity.name!)"))
            } catch {
                completion(.failure(message: "Failed to update \(entity.entity.name!)"))
            }
        }
    }
    
    
    
    //MARK: Delete entity
    func delete(entity: NSManagedObject, content: [String: Any], completion: @escaping(Result<String>) -> Void) {
        self.context.perform {
            do {
                self.context.delete(entity)
                if self.context.hasChanges {
                    try self.context.save()
                }
                completion(.success(data: "Successfully deleted \(entity.entity.name!)"))
            } catch {
                completion(.failure(message: "Failed to update \(entity.entity.name!)"))
            }
        }
    }
}

