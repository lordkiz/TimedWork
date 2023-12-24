//
//  SidebarCollectionViewItem.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa

class SidebarCollectionViewItem: NSCollectionViewItem {

    @IBOutlet var titleText: NSTextField!
    
    
    @IBOutlet var itemImageView: NSImageView!
    
    private var mouseOverArea: NSTrackingArea!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 5).isActive = true
        titleText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        itemImageView.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
        
        
        mouseOverArea = NSTrackingArea(rect: view.bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: view)
        view.addTrackingArea(mouseOverArea)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        print(event)
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
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        print(titleText.stringValue)
    }
    
    deinit {
        view.removeTrackingArea(mouseOverArea)
    }
    
    private var hovering: Bool = false {
        didSet {
            view.setNeedsDisplay(view.bounds)
            drawViewBackground()
        }
    }
    
    func updateViews(data: SidebarItem) {
        titleText.stringValue = data.title
        if (data.image != nil) {
            itemImageView.image = data.image
        }
    }
    
    private func drawViewBackground() {
        if (hovering) {
            view.layer?.backgroundColor = NSColor(named: "HoverColor")?.cgColor
        } else {
            view.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
}

extension SidebarCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "SidebarCollectionViewItem")
}
