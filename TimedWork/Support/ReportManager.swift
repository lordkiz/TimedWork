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
