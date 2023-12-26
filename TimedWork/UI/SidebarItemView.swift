//
//  SidebarItemView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 24.12.23.
//

import Cocoa

class SidebarItemView: NSView {
    
    private var mouseOverArea: NSTrackingArea!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        mouseOverArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self)
        addTrackingArea(mouseOverArea)
        NSColor(named: "Primary")?.set()
        if hovering {
            let path = NSBezierPath(rect: bounds)
            path.fill()
        }
    }
    
    deinit {
        removeTrackingArea(mouseOverArea)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if !hovering {
            hovering = true
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if hovering {
            hovering = false
        }
    }
    
    private var hovering: Bool = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
}
