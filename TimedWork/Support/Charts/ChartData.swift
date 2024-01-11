//
//  ChartData.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa


struct ChartData: Comparable {
    
    // color of the segment
    var color: NSColor
    
    // name of the segment
    var name: String?
    
    //image
    var image: NSImage?
    
    // value of the segment
    var value: Double
    
    func labelFormatter(formatter: @escaping (_: Double) -> String) -> String {
        return formatter(value)
    }
    
    static func < (lhs: ChartData, rhs: ChartData) -> Bool {
        return lhs.value < rhs.value
    }
}
