//
//  TasksTableView.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


class TasksTableView: UITableView {
    
    let tasks: [Task]
    
    
    init(frame: CGRect, tasks: [Task]) {
        self.tasks = tasks
        
        super.init(frame: frame, style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func numberOfRows(inSection section: Int) -> Int {
        return tasks.count
    }
    
    
    
    
}
