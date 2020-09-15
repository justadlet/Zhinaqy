//
//  Task.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


extension Task {
    
    ///Returns type of the task as a NewTaskState variable
    var typeAsEnum: NewTaskState {
        if self.type == "task" {
            return .task
        } else if self.type == "event" {
            return .event
        } else {
            return .habit
        }
    }
    
    
    ///Returns current progress, range = { 0.0, 1.0 }
    var currentProgress: CGFloat {
        if self.type == "task" {
            switch self.step {
            case "inProgress":
                return 0.5
            case "done":
                return 1.0
            default:
                return 0.0
            }
        } else if self.type == "habit" && count > 0 {
            return CGFloat(self.progress)/CGFloat(self.count)
        }
        return 1.0
    }
    
    
    ///Returns next step
    var nextStep: String {
        if self.step == "pending" {
            return "inProgress"
        }
        return "done"
    }
    
    
    ///Returns prev step
    var prevStep: String {
        if self.step == "done" {
            return "inProgress"
        }
        return "pending"
    }
    
}
