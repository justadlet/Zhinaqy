//
//  CoreDataError.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

enum CoreDataError: String, Error {
    ///Failed to load persistent container
    case loadFailed = "Failed to load persistent container"
    
    ///Failed to save context
    case saveFailed = "Failed to save context"
    
    ///Failed to create entity
    case createFailed = "Failed to create entity"
    
    ///Failed to update entity
    case updateFailed = "Failed to update entity"
    
    ///Failed to delete entity
    case deleteFailed = "Failed to delete entity"
}
