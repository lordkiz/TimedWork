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
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        titleText.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        titleText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        titleText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        chevronImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        titleText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}

extension SidebarHeaderView {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "SidebarHeaderView")
}
