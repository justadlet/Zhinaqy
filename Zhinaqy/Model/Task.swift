//
//  Task.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation


extension Task {
    
    func sameDay(as date: Date) -> Bool {
        
        if self.type == "task" {
            return self.start?.same(.day, as: date) ?? false
        } else if self.type == "habit" {
            if let start = self.start, let end = self.end {
                var difference = Int(date.start(of: .weekOfYear).timeIntervalSince1970 - start.start(of: .weekOfYear).timeIntervalSince1970)
                difference /= 60*60*24*7
                
                let repeatEnabled = self.repeats > 0 && difference % Int(self.repeats) == 0
                if start <= date.start(of: .day) && end > date.start(of: .day).increment(.day) && repeatEnabled && (self.days?.contains(date.string(state: .weekDay).capitalized) ?? false) {
                    return true
                }
            }
            
            return false
        }  else if self.type == "event" {
            return self.start?.same(.day, as: date) ?? false
        }
        
        return false
    }
    
}
