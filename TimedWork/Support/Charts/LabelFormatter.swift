//
//  LabelFormatter.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 07.01.24.
//

import Cocoa

struct LabelFormatter {
  private let _getLabel: (ChartData) -> String
  init(_ getLabel: @escaping (ChartData) -> String) {
    self._getLabel = getLabel
  }
  func getLabel(for segment: ChartData) -> String {
    return _getLabel(segment)
  }
}

extension LabelFormatter {
  /// Display the segment's name along with its value in parentheses.
  static let nameWithValue = LabelFormatter { segment in
    let formattedValue = NumberFormatter.toOneDecimalPlace
      .string(from: segment.value as NSNumber) ?? "\(segment.value)"
      return "\(String(describing: segment.name ?? "")) (\(formattedValue))"
  }

  /// Only display the segment's name.
    static let nameOnly = LabelFormatter { $0.name ?? "" }
}
