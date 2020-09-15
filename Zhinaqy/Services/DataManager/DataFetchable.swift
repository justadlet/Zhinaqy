//
//  DataFetchable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import CoreData


protocol DataFetchable {
    
    ///NSFetchedResultsController
    typealias fetchController = NSFetchedResultsController
    
    ///Fetch data from context
    func fetchData(completion: @escaping() -> ())
}
