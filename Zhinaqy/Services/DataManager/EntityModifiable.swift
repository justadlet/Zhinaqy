//
//  Modifiable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import CoreData

protocol EntityModifiable {
    
    ///Create one entity
    func create(name: String,
                content: [String: Any],
                completion: @escaping(CoreDataResult) -> ())
    
    ///Update one entity
    func update(entity: NSManagedObject,
                content: [String: Any],
                completion: @escaping(CoreDataResult) -> ())
    
    ///Delete one entity
    func delete(entity: NSManagedObject,
                completion: @escaping(CoreDataResult) -> ())
}
