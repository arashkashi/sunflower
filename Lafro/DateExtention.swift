//
//  DateExtention.swift
//  Sunflower
//
//  Created by Arash K. on 29/10/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import Foundation

extension NSDate {
    func isToday() -> Bool {
        var dateComponents = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: self)
        var todayComponents = NSCalendar.currentCalendar().components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: NSDate())
        
        return todayComponents.day == dateComponents.day && todayComponents.month == dateComponents.month && todayComponents.year == todayComponents.year
    }
    
    func isFuture() -> Bool {
        return self.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    
    func isPast() -> Bool {
        return self.compare(NSDate()) == NSComparisonResult.OrderedAscending
    }
    
    func toString(format: String) -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
}
