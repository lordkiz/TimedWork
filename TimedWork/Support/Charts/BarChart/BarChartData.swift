//
//  BarChartData.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 26.12.23.
//

import Cocoa

struct BarChartData: Comparable {
    
    // color of the bar
    var color: NSColor
    
    // name of the bar
    var name: String?
    
    // value of the bar
    var value: Double
    
    static func < (lhs: BarChartData, rhs: BarChartData) -> Bool {
        return lhs.value < rhs.value
    }
}
