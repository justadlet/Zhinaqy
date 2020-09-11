//
//  ViewModelFactory.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation

protocol ViewModelFactory {
    func makePlansViewModel() -> PlansViewModel
    func makeNewTaskViewModel(task: Task?) -> NewTaskViewModel
    
}
