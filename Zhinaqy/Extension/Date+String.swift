//
//  Date+String.swift
//  Zhinaqy
//
//  Created by Kuanysh Anarbay on 9/8/20.
//  Copyright © 2020 Kuanysh Anarbay. All rights reserved.
//

import UIKit


extension Date {
    
    enum State: String {
        case dateTime = "MMM d, HH:mm"
        case monthDay = "MMM d"
        case monthDayYear = "MMM d, YYYY"
        case monthYear = "MMMM YYYY"
        case time = "HH:mm"
        case weekDay
    }
    
    //MARK: Returns date as string
    func string(state: State) -> String {
        if state.rawValue == "weekDay" {
            let dateFormatter = DateFormatter()
            return dateFormatter.shortWeekdaySymbols[self.element(.weekday) - 1].lowercased()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = state.rawValue
            
            return dateFormatter.string(from: self)
        }
    }
    
}
