//
//  BatchRequestable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import CoreData

protocol BatchRequestable {
    
    ///Execute batch request
    func execute(in privateContext: NSManagedObjectContext,
                 with request: NSPersistentStoreRequest,
                 completion: @escaping (CoreDataResult) -> ())
    
    ///Create many entities
    func create(name: String,
                content: [[String: Any]],
                completion: @escaping(CoreDataResult) -> ())
    
    ///Update many entities
    func update(name: String,
                content: [String: Any],
                predicate: NSPredicate?,
                completion: @escaping(CoreDataResult) -> ())
    
    ///Delete many entities
    func delete(name: String,
                predicate: NSPredicate?,
                completion: @escaping(CoreDataResult) -> ())

}
