//
//  Progressable.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/15/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

protocol Progressable {
    func increment(task: Task)
    func decrement(task: Task)
}
