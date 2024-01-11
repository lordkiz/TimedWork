//
//  DashboardViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.01.24.
//

import Cocoa

class DashboardViewController: NSViewController {

    static var reportersHorizontalLeaderBarId = "reportersHorizontalLeaderBarId1"
    
    var selectedDates: (Date?, Date?) = (Date().subtractMonth(month: 1), Date()) {
        didSet {
            setUpSelectedDatesLabel()
            getReports()
            prepareData()
        }
    }
    
    var reports: [Report] = ReportManager.shared.getReports(from: Date().subtractMonth(month: 1), to: Date())
    
    @IBOutlet var reporterLeaderBars: HorizontalLeaderBarsView!
    
    @IBOutlet var calendarView: CalendarView!
    
    @IBOutlet var selectedDatesLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        setUpSelectedDatesLabel()
        prepareData()
    }
    
    private func setUpSelectedDatesLabel() {
        var string = ""
        if let (d1, m1, y1) = selectedDates.0?.dayMonthYearIntegers {
            string += "\(String(describing: d1 ?? -1))/\(String(describing: m1 ?? -1))/\(String(describing: y1 ?? -1)) - "
        }
        if let (d2, m2, y2) = selectedDates.1?.dayMonthYearIntegers {
            string += "\(String(describing: d2 ?? -1))/\(String(describing: m2 ?? -1))/\(String(describing: y2 ?? -1))"
        }
        selectedDatesLabel.stringValue = string
    }
    
    private func getReports() {
        if let start = selectedDates.0, let end = selectedDates.1 {
            reports = ReportManager.shared.getReports(from: start, to: end)
        }
    }
    
    private func prepareData() {
        var reportsDict: Dictionary<Reporter, Double> = [:]
        for report in reports {
            let timeInterval = report.endDate!.timeIntervalSince(report.startDate!)
            reportsDict[report.reporter!] = (reportsDict[report.reporter!] ?? 0) + timeInterval
        }
        let chartData: [ChartData] = reportsDict.map({ k, v in
            let icon = k.getIcon()
            let color: NSColor = icon?.getColors(quality: .lowest)?.primary ?? .systemOrange
            return ChartData(color: color, name: k.appName, image: icon, value: v)
        }).sorted(by: { d1, d2 in
            d2 < d1
        })
        
        reporterLeaderBars.formatterDelegate = self
        reporterLeaderBars.id = Self.reportersHorizontalLeaderBarId
        reporterLeaderBars.data = chartData
    }
}

extension DashboardViewController: CalendarViewDelegate {
    func didSelectDates(_ dates: (Date?, Date?)) {
        selectedDates = dates
    }
}

extension DashboardViewController: ChartLabelFormatterDelegate {
    func formatValue(_ value: Any, _ senderId: String) -> String {
        if senderId == DashboardViewController.reportersHorizontalLeaderBarId {
            return (value as! TimeInterval).stringFromTimeInterval()
        }
        return ""
    }
}
