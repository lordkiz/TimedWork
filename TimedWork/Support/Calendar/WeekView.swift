//
//  WeekView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa

class WeekView: NSView {
    var calendarDayViewDelegate: CalendarDayViewDelegate?
    
    var dates: [Date] = [] {
        didSet {
            tearDown()
            setUp()
        }
    }
    
    var dayViews: [DayView] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    
    func setUp() {
        dayViews = []
        var x: CGFloat = 0
        for date in dates {
            let dayView = DayView(date: date, frame: NSMakeRect(x, 0, bounds.size.width/7, bounds.size.height))
            dayView.delegate = calendarDayViewDelegate
            x = dayView.frame.maxX
            addSubview(dayView)
            dayViews.append(dayView)
        }
    }
    
    func tearDown() {
        for dayView in dayViews {
            dayView.tearDown()
            dayView.removeFromSuperview()
        }
        dayViews = []
    }
    
}
