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
    
    var dayMonthYearIntegers: (Int?, Int?, Int?) {
        let components = NSCalendar.current.dateComponents([.day, .month,.year], from: self)
        return (components.day, components.month, components.year)
    }
    
    func dayOfTheYear() -> Int? {
        let calendar = NSCalendar.current
        return calendar.ordinality(of: .day, in: .year, for: self)
    }
    
    func isSameYear(_ date: Date) -> Bool {
        let (_, _, y) = self.dayMonthYearIntegers
        let (_, _, ty) = date.dayMonthYearIntegers
        let isSameYear = y != nil && ty != nil && y! == ty!
        return isSameYear
    }
    
    func isSameMonth(_ date: Date) -> Bool {
        let (_, m, _) = self.dayMonthYearIntegers
        let (_, tm, _) = date.dayMonthYearIntegers
        let isSameMonth = isSameYear(date) && m != nil && tm != nil && m! == tm!
        return isSameMonth
    }
    
    func isSameDay(_ date: Date) -> Bool {
        let (d, _, _) = self.dayMonthYearIntegers
        let (td, _, _) = date.dayMonthYearIntegers
        let isSameDay = isSameYear(date) && isSameMonth(date) && d != nil && td != nil && d! == td!
        return isSameDay
    }
    
    
    
    func isBeforeOrSameDay(_ date: Date) -> Bool {
        let (_, m, y) = self.dayMonthYearIntegers
        let (_, tm, ty) = date.dayMonthYearIntegers
        // sum of all months since 00 AD
        let sum = (y! * 12) + (m!)
        let sumT = (ty! * 12) + (tm!)
        if sum < sumT { return true }
        // At this point both dates are >= month
        return self.dayOfTheYear()! <= date.dayOfTheYear()!
    }
    
    func isBeforeOrToday() -> Bool {
        return isBeforeOrSameDay(Date())
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
}

// MARK: - Calculations
extension Date {
    func addOrSubtractDay(day: Int) -> Date {
      return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }
    
    func subtractDay(day: Int) -> Date {
      return Calendar.current.date(byAdding: .day, value: -day, to: self)!
    }
    
    func addDay(day: Int) -> Date {
      return Calendar.current.date(byAdding: .day, value: day, to: self)!
    }

    func subtractMonth(month: Int) -> Date {
      return Calendar.current.date(byAdding: .month, value: -month, to: self)!
    }
    
    func addMonth(month: Int) -> Date {
      return Calendar.current.date(byAdding: .month, value: month, to: self)!
    }
    
    func addOrSubtractMonth(month: Int) -> Date{
      return Calendar.current.date(byAdding: .month, value: month, to: self)!
    }
    
    func subtractYear(year: Int) -> Date {
      return Calendar.current.date(byAdding: .year, value: -year, to: self)!
    }
    
    func addYear(year: Int) -> Date {
      return Calendar.current.date(byAdding: .year, value: year, to: self)!
    }

    func addOrSubtractYear(year:Int) -> Date{
      return Calendar.current.date(byAdding: .year, value: year, to: self)!
    }
}
