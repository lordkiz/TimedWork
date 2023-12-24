//
//  ActivityManager.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 03.12.23.
//

import Cocoa

class ActivityManager: NSObject {
    static let shared: ActivityManager = ActivityManager()
    
    var fetchRequest: NSFetchRequest<Activity>!
    
    override init() {
        super.init()
        fetchRequest = Activity.fetchRequest()
    }
    
    var activities: [Activity]  {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return [] }
        guard let activities = try? app.persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return activities
    }
    
    func createActivity(name: String, selectedApps: [InstalledApp]) -> Bool {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return false }
        let viewContext = app.persistentContainer.viewContext
        
        if let activityEntity = NSEntityDescription.entity(forEntityName: "Activity", in: viewContext) {
            let activity = NSManagedObject(entity: activityEntity, insertInto: viewContext) as! Activity
            activity.name = name
            app.saveAction(self)
            
            var savedActivity: Activity
            do {
                savedActivity = try viewContext.existingObject(
                    with: activity.objectID
                ) as! Activity
            } catch {
                return false
            }
            for selectedApp in selectedApps {
                if let rep = ReporterManager.shared.fetchReporterBy(appUrl: selectedApp.appUrl.absoluteString) {
                    rep.addToActivities(savedActivity)
                    savedActivity.addToReporters(rep)
                } else {
                    guard let rep = ReporterManager.shared.createReporter(installedApp: selectedApp) else { break }
                    rep.addToActivities(savedActivity)
                    savedActivity.addToReporters(rep)
                }
            }
        }
        
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("saved activity")
                return true
            } catch {
                let nserror = error as NSError
                print("unable to save \(error), \(error.localizedDescription)")
                return false
            }
        }
        return false
    }
}
