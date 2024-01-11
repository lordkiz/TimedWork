//
//  ChartLabelFormatterDelegate.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 11.01.24.
//

import Cocoa

protocol ChartLabelFormatterDelegate {
    func formatValue(_ value: Any, _ senderId: String) -> String
}
