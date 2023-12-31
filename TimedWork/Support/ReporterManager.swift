//
//  ReporterManager.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.12.23.
//

import Cocoa

class ReporterManager: NSObject {
    static let shared: ReporterManager = ReporterManager()
    
    override init() {
        super.init()
    }
    
    var reporters: [Reporter]  {
        let fetchRequest: NSFetchRequest<Reporter> = Reporter.fetchRequest()
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return [] }
        guard let reporters = try? app.persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return reporters
    }
    
    func fetchReporterBy(appUrl url: String) -> Reporter? {
        let fetchRequest: NSFetchRequest<Reporter> = Reporter.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "appUrl LIKE %@", url
        )
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return nil }
        guard let reporters = try? app.persistentContainer.viewContext.fetch(fetchRequest) else { return  nil }
        return reporters.first
    }
    
    func createReporter(installedApp: InstalledApp) -> Reporter? {
        guard let reporter = fetchReporterBy(appUrl: installedApp.appUrl.absoluteString) else {
            guard let app = NSApplication.shared.delegate as? AppDelegate else { return nil }
            let viewContext = app.persistentContainer.viewContext
            
            if let reporterEntity = NSEntityDescription.entity(forEntityName: "Reporter", in: viewContext) {
                let rep = NSManagedObject(entity: reporterEntity, insertInto: viewContext) as! Reporter
                rep.appUrl = installedApp.appUrl.absoluteString
                rep.appName = installedApp.appName
                rep.internalID = UUID()
                app.saveAction(self)
                return rep
            }
            return nil
        }
        return reporter
    }
}


extension Reporter {
    func getIcon() -> NSImage? {
        guard let url = self.appUrl == nil ? nil : URL(string: self.appUrl!) else { return nil }
        if #available(macOS 13.0, *) {
            return NSWorkspace.shared.icon(forFile: url.path(percentEncoded: false))
        } else {
            return NSWorkspace.shared.icon(forFile: url.path)
        }
    }
}
