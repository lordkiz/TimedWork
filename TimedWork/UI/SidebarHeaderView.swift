//
//  SidebarHeaderCollectionViewItem.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa

class SidebarHeaderView: NSView {
    
    @IBOutlet var titleText: NSTextField!
    
    @IBOutlet var chevronImageView: NSImageView!
    
    private var mouseOverArea: NSTrackingArea!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        mouseOverArea = NSTrackingArea(rect: bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self)
        addTrackingArea(mouseOverArea)
        NSColor(named: "HoverColor")?.set()
        if hovering {
            let path = NSBezierPath(rect: bounds)
            path.fill()
            
        }
        
        titleText.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        titleText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        titleText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        chevronImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        titleText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    deinit {
        removeTrackingArea(mouseOverArea)
    }
    
    private var hovering: Bool = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
}

extension SidebarHeaderView {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "SidebarHeaderView")
}
