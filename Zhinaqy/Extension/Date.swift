//
//  Date.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation


extension Date {
    
    
    ///Init from string
    init(_ isoDate: String) {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        self = dateFormatter.date(from: isoDate)!
    }
    
    ///Init with date and time
    init(date: Date, time: Date){
        
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.hour = Calendar.current.component(.hour, from: time)
        components.minute = Calendar.current.component(.minute, from: time)
    
        self = Calendar.current.date(from: components)!
    }
    
    var darkMode: Bool {
        let hh = Calendar.current.component(.hour, from: self)
        
        return hh <= 6 || hh >= 20
    }
    
    var time: Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        return Calendar.current.date(from: components)!
    }
    
    /**
    Increment current day by a value

    - Parameters:
       - count: Incrementation value
       - component: Incrementation type: .day, .weekOfYear, .month

    - Returns: Incremented date
    */
    func increment(by count: Int = 1, _ component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: count, to: self)!
    }
    
    
    func start(of component: Calendar.Component) -> Date {
        switch component {
        case .day:
            let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
            return Calendar.current.date(from: components)!
        case .month:
            let components = Calendar.current.dateComponents([.year, .month], from: self)
            return Calendar.current.date(from: components)!
        case .weekOfYear:
            let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
            return Calendar.current.date(from: components)!
        default:
            return self
        }
    }
    
    
    
    
    //MARK: Check is same day
    func same(_ component: Calendar.Component, as date: Date) -> Bool {
        let components: [Calendar.Component] = [ .year, .month, .weekOfMonth, .day, .hour, .minute, .second]
        
        for item in components {
            if Calendar.current.component(item, from: self) != Calendar.current.component(item, from: date) {
                return false
            }
            if item == component {
                break
            }
        }
        
        return true
    }
    
    
    
}
