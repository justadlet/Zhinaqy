//
//  Date+Int.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/11/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import Foundation


extension Date {
    
    func element(_ component: Calendar.Component) -> Int {
        return Calendar.current.component(component, from: self)
    }
    
    
    //MARK: Returns number of elements from week, month, year
    func count(get: Calendar.Component, from: Calendar.Component) -> Int {
        return Calendar.current.range(of: get, in: from, for: self)?.count ?? 4
    }
}
