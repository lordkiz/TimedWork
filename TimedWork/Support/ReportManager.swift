//
//  ReportManager.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.12.23.
//

import Cocoa

enum ReportType: Int, CustomStringConvertible {
    case meeting, work
    var description: String {
        switch self {
        case .meeting: return "meeting"
        case .work: return "work"
        }
    }
}

struct PermittedReportValues {
    let endDate: Date?
    let startDate: Date?
    let type: ReportType? 
}

class ReportManager: NSObject {
    static let shared: ReportManager = ReportManager()
    override init() {
        super.init()
    }
    
    func createReport(type: ReportType, startDate: Date, endDate: Date?, reporter: Reporter?, activity: Activity?) -> Report? {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return nil }
        let viewContext = app.persistentContainer.viewContext
            
        if let reportEntity = NSEntityDescription.entity(forEntityName: "Report", in: viewContext) {
            let report = NSManagedObject(entity: reportEntity, insertInto: viewContext) as! Report
            report.type = type.description
            report.startDate = startDate
            report.endDate = endDate
            report.internalID = UUID()
            report.activity = activity
            report.reporter = reporter
            app.saveAction(self)
            return report
        }
        return nil
    }
    
    var reports: [Report]  {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return [] }
        let fetchRequest = Report.fetchRequest()
        guard let reports = try? app.persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return reports
    }
    
    func getReports(from start: Date, to end: Date) -> [Report] {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return [] }
        let viewContext = app.persistentContainer.viewContext
        let request = Report.fetchRequest()
        request.predicate = NSPredicate(format: "(startDate >= %@) AND (endDate <= %@)", argumentArray: [start, end])
        guard let reports = try? viewContext.fetch(request) else { return [] }
        return reports
    }
    
    func getReport(byID id: UUID) -> Report? {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return nil }
        let viewContext = app.persistentContainer.viewContext
        let request = Report.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "internalID", id as CVarArg)
        guard let reports = try? viewContext.fetch(request) else { return nil }
        return reports.first
    }
    
    /** Return all reports that do not have an endDate */
    func getAllOpenReports() -> [Report]? {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return nil }
        let viewContext = app.persistentContainer.viewContext
        let request = Report.fetchRequest()
        request.predicate = NSPredicate(format: "%K == nil", "endDate")
        guard let reports = try? viewContext.fetch(request) else { return nil }
        return reports
    }
    
    private func update(report: Report, values: PermittedReportValues) {
        report.endDate = values.endDate
        report.startDate = values.startDate
        report.type = values.type?.description
        do {
            
            let viewContext = (NSApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
            try viewContext.save()
        } catch {
            // TODO
            print("error updating report")
        }
    }
    
    func update(report: Report, values: PermittedReportValues, permitNil: Bool = false) {
        if permitNil {
            return update(report: report, values: values)
        }
        if (values.endDate != nil) {
            report.endDate = values.endDate
        }
        if (values.startDate != nil) {
            report.startDate = values.startDate
        }
        if values.type != nil {
            report.type = values.type?.description
        }
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return }
        let viewContext = app.persistentContainer.viewContext
        do {
            try viewContext.save()
        } catch {
            // TODO
            print("error updating report")
        }
    }
}


// MARK: - UTILS

enum ReportGroupPeriodEnum: Int, CustomStringConvertible {
    case day, week, month, threeMonths, sixMonths, oneYear
    var description: String {
        switch self {
        case .day: return "24 Hours"
        case .week: return "One week"
        case .month: return "One month"
        case .threeMonths: return "Three months"
        case .sixMonths: return "Six months"
        case .oneYear: return "One year"
        }
    }
}

struct GroupedReport {
    let from: Date?
    let to: Date?
    let month: String?
    let day: String?
    var reports: NSArray
    func sum() -> Double {
        (reports as! [Report]).lazy.map { report in
            if (report.endDate == nil || report.startDate == nil) { return 0 }
            return report.endDate!.timeIntervalSince(report.startDate!)
        } .reduce(0, +)
    }
}

extension ReportManager {
    func getGroupedReports(period: ReportGroupPeriodEnum) -> [GroupedReport] {
        let reports = getReportsForPeriod(period)
        return prepareGrouped(reports: reports, for: period)
    }
    
    
    func getReportsFor(activity: Activity, period: ReportGroupPeriodEnum) -> [GroupedReport] {
        let reports = activity.reports
        return prepareGrouped(reports: reports?.allObjects as? [Report] ?? [], for: period)
    }
    
    private func prepareGrouped(reports: [Report], for period: ReportGroupPeriodEnum) -> [GroupedReport] {
        var initial: [GroupedReport] {
            return getStartAndEndDateChunksForPeriod(period).map{ tuple in
                
                return GroupedReport(
                    from: (tuple as! [Date?])[0],
                    to: (tuple as! [Date?])[1],
                    month: (tuple as! [Date?])[1]?.monthName(),
                    day: period == .week ? (tuple as! [Date?])[1]?.dayName() : nil,
                    reports: NSArray()
                )
            }
        }
        var result = NSMutableArray(array: initial)
        let periodChunks = getStartAndEndDateChunksForPeriod(period)
        for report in reports {
            let index = getGroupIndexInPeriodChunkForReport(periodChunks: periodChunks as! [[Date?]], report: report)
            if (index > -1) {
                let groupedReport = (result as! [GroupedReport])[index]
                var r = NSMutableArray(array: (result as! [GroupedReport])[index].reports)
                r.add(report)
                let newGroupedReport = GroupedReport(from: groupedReport.from, to: groupedReport.to, month: groupedReport.month, day: groupedReport.day, reports: r)
                result[index] = newGroupedReport
            }
        }
        return result as! [GroupedReport]
    }
    
    private func getGroupCount(_ period: ReportGroupPeriodEnum) -> Int{
        switch period {
        case .day: return 4
        case .week: return 7
        case .month: return 5
        case .threeMonths: return 6
        case .sixMonths: return 6
        case .oneYear: return 12
        }
    }
    
    func getStartAndEndDateChunksForPeriod(_ period: ReportGroupPeriodEnum) -> NSMutableArray {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let groupCount = getGroupCount(period)
        switch period {
        // Date since 12:00 AM yesterday
        case .day: return makeChunks(numberOfHours: Double(now.hour!), numberOfDays: 1, totalChunks: Double(groupCount))
        case .week: return makeChunks(numberOfDays: 7, totalChunks: Double(groupCount))
        case .month: return makeChunks(numberOfDays: 30, totalChunks: Double(groupCount))
        case .threeMonths: return makeChunks(numberOfDays: 30 * 3, totalChunks: Double(groupCount))
        case .sixMonths: return makeChunks(numberOfDays: 30 * 6, totalChunks: Double(groupCount))
        case .oneYear: return makeChunks(numberOfDays: 365, totalChunks: Double(groupCount))
        }
    }
    
    private func makeChunks(numberOfHours: Double? = 24, numberOfDays: Double, totalChunks: Double) -> NSMutableArray {
        let res = NSMutableArray()
        let totalHours = (24 * numberOfDays)
        let hourChunk = totalHours/totalChunks
        var tuple = NSMutableArray()
        let secondsElapsed = -(60 * 60 * numberOfHours! * numberOfDays)
        var startDate = Date.init(timeIntervalSinceNow: TimeInterval(secondsElapsed))
        for _ in stride(from: hourChunk, through: totalHours, by: hourChunk) {
            let endDate: Date = Date(timeIntervalSinceNow: startDate.timeIntervalSinceNow + Double((60 * 60 * hourChunk)))
            tuple.add(startDate)
            tuple.add(endDate)
            if tuple.count == 2 {
                res.add(tuple)
                tuple = NSMutableArray()
            }
            startDate = endDate
        }
        return res
    }
    
    // Given a StartAndEndDateChunksForPeriod, find the index in the chunk that the report belongs to
    private func getGroupIndexInPeriodChunkForReport(periodChunks: [[Date?]], report: Report) -> Int {
        for (index, chunk) in periodChunks.enumerated() {
            guard let end = chunk[1] else { return -1 }
            let comparisonResult = report.endDate?.compare(end)
            if comparisonResult == .orderedAscending || comparisonResult == .orderedSame { return index }
        }
        return -1
    }
    
    private func getReportsForPeriod(_ period: ReportGroupPeriodEnum) -> [Report] {
        let dateChunks = getStartAndEndDateChunksForPeriod(period)
        let start = (dateChunks[0] as! [Date])[0], end = Date.init()
        return getReports(from: start, to: end)
    }
}
