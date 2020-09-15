//
//  CoreDataResult.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

enum CoreDataResult {
    ///Success result
    case success
    
    ///Error occured, with parameter
    case error(type: CoreDataError)
    
    ///Wrong parameter
    case wrongParameter(message: String)
}
