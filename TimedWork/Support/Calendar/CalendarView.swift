//
//  CalendarView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.01.24.
//

import Cocoa

@IBDesignable
class CalendarView: NSView {
    var delegate: CalendarViewDelegate?
    
    var currentMonthView: MonthView? = nil
    
    var leftButton: NSButton?
    var rightButton: NSButton?
    
    var textField: NSTextField!
    
    var date: Date = Date() {
        didSet {
            currentMonthView?.tearDown()
            currentMonthView?.removeFromSuperview()
            textField.removeFromSuperview()
            setup()
        }
    }
    
    var selectedDays: (DayView?, DayView?) = (nil, nil) {
        didSet {
            let (date1, date2) = (selectedDays.0?.date, selectedDays.1?.date)
            var sorted = (date1, date2)
            if date1 != nil && date2 != nil && date2!.isBeforeOrSameDay(date1!) {
                sorted = (date2, date1)
            }
            delegate?.didSelectDates(sorted)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    @objc func onLeftButtonClick(_ sender: NSButton) {
        date = date.subtractMonth(month: 1)
        print(date)
    }
    
    @objc func onRightButtonClick(_ sender: NSButton) {
        date = date.addMonth(month: 1)
    }
    
    
    private func setup() {
        setValue(NSColor(named: "HoverColor"), forKey: "backgroundColor")
        let monthView = MonthView(frame: bounds.insetBy(dx: 60, dy: 60))
        monthView.calendarDayViewDelegate = self
        monthView.date = date
        addSubview(monthView)
        currentMonthView = monthView
        
        // add buttons
        leftButton?.removeFromSuperview()
        rightButton?.removeFromSuperview()
        
        let imageConfig = NSImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        
        leftButton = NSButton(title: "", target: self, action: #selector(onLeftButtonClick(_:)))
        let leftButtonImage = NSImage(systemSymbolName: "chevron.left", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
        leftButton!.image = leftButtonImage
        addSubview(leftButton!)
        leftButton!.wantsLayer = true
        leftButton!.layer?.backgroundColor = .clear
        leftButton!.isBordered = false
        leftButton?.translatesAutoresizingMaskIntoConstraints = false
        leftButton!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        leftButton!.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        
        
        if !date.isSameMonth(Date()) {
            rightButton = NSButton(title: "", target: self, action: #selector(onRightButtonClick(_:)))
            rightButton!.action = #selector(onRightButtonClick(_:))
            let rightButtonImage = NSImage(systemSymbolName: "chevron.right", accessibilityDescription: nil)?.withSymbolConfiguration(imageConfig)
            rightButton!.image = rightButtonImage
            addSubview(rightButton!)
            rightButton!.wantsLayer = true
            rightButton!.layer?.backgroundColor = .clear
            rightButton!.isBordered = false
            rightButton!.translatesAutoresizingMaskIntoConstraints = false
            rightButton!.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            rightButton!.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        }
        
        // Add Label
        textField = NSTextField(frame: NSRect(x: 0, y: 0, width: 100, height: 40))
        let (_, _, year) = date.dayMonthYearIntegers
        textField.stringValue = "\(date.monthName()) \(year ?? -1)"
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.font = NSFont.systemFont(ofSize: 16)
        

        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: topAnchor, constant: 25).isActive = true
    }
}

extension CalendarView: CalendarDayViewDelegate {
    func didSelectDay(_ dayView: DayView) {
        dayView.selected = true
        let (day1, day2) = selectedDays
        if day1 == nil && day2 == nil {
            selectedDays = (dayView, day2)
        } else if day2 == nil {
            selectedDays = (day1, dayView)
        } else {
            // both are selected, so we start afresh
            selectedDays.0?.selected = false
            selectedDays.1?.selected = false
            selectedDays = (dayView, nil)
        }
    }
    
    func didUnselectDay(_ dayView: DayView) {
        dayView.selected = false
        let (day1, day2) = selectedDays
        if let date1 = day1?.date {
            if date1.isSameDay(dayView.date!) {
                selectedDays = (day2, nil)
                return
            }
        }
        if let date2 = day2?.date {
            if date2.isSameDay(dayView.date!) {
                selectedDays = (day1, nil)
                return
            }
        }
    }
}

