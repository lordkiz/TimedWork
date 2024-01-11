//
//  CalendarDelegate.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 10.01.24.
//

import Cocoa

protocol CalendarViewDelegate {
    // Calls back with the selected dates
    func didSelectDates(_ dates: (Date?, Date?))
}
