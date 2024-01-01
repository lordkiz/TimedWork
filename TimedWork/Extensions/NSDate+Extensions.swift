//
//  NSDate+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 31.12.23.
//

import Cocoa

extension Date {
    func monthName() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("MMM")
        return df.string(from: self)
    }
    
    func dayName() -> String {
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEEE")
        return df.string(from: self)
    }
}
