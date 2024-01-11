//
//  DayView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa

class DayView: NSView {
    var delegate: CalendarDayViewDelegate?
    
    var date: Date! {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var selectable: Bool! {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var selected: Bool = false {
        didSet {
            tearDown()
            setUp()
            setNeedsDisplay(bounds)
        }
    }
    
    var textField: NSTextField!
    
    init(date dayDate: Date, frame: NSRect) {
        super.init(frame: frame)
        date = dayDate
        selectable = date.isBeforeOrToday()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    
    override func mouseDown(with event: NSEvent) {
        if !selectable { return }
        if (selected) {
            delegate?.didUnselectDay(self)
        } else {
            delegate?.didSelectDay(self)
        }
    }
    
    func setUp() {
        wantsLayer = true
        layer?.borderWidth = 1
        layer?.borderColor = NSColor.darkGray.cgColor
        if selected {
            setValue(NSColor.orange, forKey: "backgroundColor")
            layer?.borderColor = NSColor.orange.cgColor
            layer?.opacity = 1
        } else if selectable {
            setValue(NSColor.clear, forKey: "backgroundColor")
            layer?.opacity = 1
        } else {
            setValue(NSColor.clear, forKey: "backgroundColor")
            layer?.opacity = 0.3
        }
        
        
        let (dayInt, _ , _) = date?.dayMonthYearIntegers ?? (0,0,0)
        let dayNumberString = "\(String(describing: dayInt ?? 0))"
        
        textField = NSTextField(frame: bounds.insetBy(dx: 10, dy: 10))
        textField.stringValue = dayNumberString
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isBezeled = false
        textField.alignment = .center
        textField.font = NSFont.systemFont(ofSize: 16)
        

        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    func tearDown() {
        textField.removeFromSuperview()
    }
}


