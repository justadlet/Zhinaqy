//
//  Contextable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import CoreData

protocol Contextable {
    ///Create new private context
    func newPrivateContext() -> NSManagedObjectContext
    
    ///Save private context
    func saveContext(_ privateContext: NSManagedObjectContext, completion: @escaping(CoreDataResult) -> ())
    
    /// Reset private context 
    func reset(_ privateContext: NSManagedObjectContext)
}
