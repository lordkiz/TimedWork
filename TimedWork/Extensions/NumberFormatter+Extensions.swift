//
//  NumberFormatter+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa

extension NumberFormatter {
  static let toOneDecimalPlace: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      formatter.minimumFractionDigits = 0
      formatter.maximumFractionDigits = 1
      return formatter
  }()
}
