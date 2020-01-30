//
//  DateFormatter+Extension.swift
//  Fowl Weather
//
//  Created by Jake Connerly on 1/29/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

extension DateFormatter {
    var sunriseDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    var todayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyy"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    var dayOfWeekFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    var hourlyTime: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        formatter.timeZone = TimeZone.current
        return formatter
    }
}
