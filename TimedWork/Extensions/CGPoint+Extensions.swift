//
//  CGPoint+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa

extension CGPoint {
    func projected(by value: CGFloat, angle: CGFloat) -> CGPoint {
        return CGPoint(x: x + value * cos(angle), y: y + value * sin(angle))
    }
}
