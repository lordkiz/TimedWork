//
//  NSImage+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 04.12.23.
//

import Cocoa

extension NSImage {
    func resize(w: CGFloat, h: CGFloat) -> NSImage {
        let desiredSize = NSMakeSize(w, h)
        let image = NSImage(size: desiredSize)
        image.lockFocus()
        self.draw(in: NSMakeRect(0, 0, desiredSize.width, desiredSize.height), from: NSMakeRect(0, 0, self.size.width, self.size.height), operation: .sourceOver, fraction: CGFloat(1))
        image.unlockFocus()
        image.size = desiredSize
        return NSImage(data: image.tiffRepresentation!)!
    }
}
