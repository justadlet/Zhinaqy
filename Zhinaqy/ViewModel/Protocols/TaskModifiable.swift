//
//  TaskModifiable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/14/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

protocol TaskModifiable {
    func delete(_ task: Task)
    func deleteAll(_ task: Task)
    func increment(_ task: Task)
    func decrement(_ task: Task)
}
