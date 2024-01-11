//
//  File.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 10.01.24.
//

import Cocoa

protocol CalendarDayViewDelegate {
    func didSelectDay(_ dayView: DayView)
    func didUnselectDay(_ dayView: DayView)
}
