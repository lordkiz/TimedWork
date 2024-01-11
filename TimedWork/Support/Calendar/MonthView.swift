//
//  MonthView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa

let weekNames: [String: Int] = [
     "Monday": 1, "Tuesday": 2, "Wednesday": 3, "Thursday": 4, "Friday": 5, "Saturday": 6, "Sunday": 7,
]

let monthLabelNames = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ]

let monthDays: [String: Int] = [
    "Jan": 31, "Feb": 28, "Mar": 31, "Apr": 30, "May": 31, "Jun": 30,
    "Jul": 31, "Aug": 31, "Sep": 30, "Oct": 31, "Nov": 30, "Dec": 31
]


class MonthView: NSView {
    var calendarDayViewDelegate: CalendarDayViewDelegate?
    
    override var isFlipped: Bool { true }
    
    var weekLabels: [NSTextField] = []
    
    var date: Date? {
        didSet {
            tearDown()
            if date != nil {
                let firstDay = date!.startOfMonth
                let lastDay = date!.endOfMonth
                numberOfDays = Int(round(lastDay.timeIntervalSince(firstDay)/86400))
            }
            setUp()
            setNeedsDisplay(bounds)
        }
    }
    
    
    let labelHeight: CGFloat = 20
    
    let inset: CGFloat = 10
    
    var weeks: [WeekView] = []
    
    let maxNumberOfWeeks = 5
    
    var numberOfDays = 30
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    
    func inflate() {
        var x: CGFloat = 0
        for name in monthLabelNames {
            let dayName = String(name.prefix(3)).capitalized
            let frame = NSMakeRect(x, inset, bounds.size.width/CGFloat(monthLabelNames.count), labelHeight)
            let label = WeekLabel(dayName: dayName, frame: frame)
            x = label.frame.maxX
            addSubview(label)
            weekLabels.append(label)
        }
        var y: CGFloat = labelHeight + inset
        for i in stride(from: 0, to: weeks.count, by: 1) {
            let week = weeks[i]
            week.frame = NSMakeRect(0, y, bounds.size.width, (bounds.size.height - (labelHeight + inset) - inset) / CGFloat(maxNumberOfWeeks))
            addSubview(week)
        
            y = week.frame.maxY
        }
    }
    
    func setUp() {
        if date == nil { return }
        weeks = []
        let firstDayOfMonth = date!.startOfMonth
        
        let nameOfFirstDayOfTheMonth = firstDayOfMonth.dayName()
        print(nameOfFirstDayOfTheMonth)
        
        // go back to previous days to fill up calendar
        let startFrom = 1 - (weekNames[nameOfFirstDayOfTheMonth] ?? 0)
        let endAt = 35 + startFrom
        
        var dates: [Date] = []
        for i in stride(from: startFrom, through: endAt, by: 1) {
            let d = firstDayOfMonth.addOrSubtractDay(day: i)
            if dates.count < 7 {
                dates.append(d)
            }
            if dates.count == 7 {
                let weekView = WeekView(frame: NSRect(x: 0, y: 0, width: bounds.width, height: bounds.size.height/CGFloat(maxNumberOfWeeks)))
                weekView.calendarDayViewDelegate = calendarDayViewDelegate
                weekView.dates = dates
                weeks.append(weekView)
                dates = []
            }
        }
        inflate()
    }
    
    func tearDown() {
        for label in weekLabels {
            label.removeFromSuperview()
        }
        for weekView in weeks {
            weekView.tearDown()
            weekView.removeFromSuperview()
        }
        weekLabels = []
        weeks = []
    }
}


class WeekLabel: NSTextField {
    init(dayName: String, frame: NSRect) {
        super.init(frame: frame)
        stringValue = dayName
        isEditable = false
        alignment = .center
        font = NSFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
