//
//  CalendarDelegate.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 10.01.24.
//

import Cocoa

protocol CalendarView
Delegate {
    // Calls back with the selected dates
    func didSelectDates(_ dates: (Date?, Date?))
}
