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
    
    private func getApp() -> AppDelegate? {
        guard let app = NSApplication.shared.delegate as? AppDelegate else { return nil }
        return app
    }
    
    var activities: [Activity]  {
        guard let app = getApp() else { return [] }
        guard let activities = try? app.persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return activities
    }
    
    func getActivity(byObjectID objectID: NSManagedObjectID) -> Activity? {
        guard let app = getApp() else { return nil }
        do {
            let activity = try app.persistentContainer.viewContext.existingObject(with: objectID)
            return activity as? Activity
        } catch {
            return nil
        }
    }
    
    func getActivity(byID id: UUID) -> Activity? {
        guard let app = getApp() else { return nil }
        let viewContext = app.persistentContainer.viewContext
        let request = Activity.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "internalID", id as CVarArg)
        guard let activities = try? viewContext.fetch(request) else { return nil }
        return activities.first
    }
    
    func createActivity(name: String, selectedApps: [InstalledApp]) -> Bool {
        guard let app = getApp() else { return false }
        let viewContext = app.persistentContainer.viewContext
        
        if let activityEntity = NSEntityDescription.entity(forEntityName: "Activity", in: viewContext) {
            let activity = NSManagedObject(entity: activityEntity, insertInto: viewContext) as! Activity
            activity.name = name
            activity.internalID = UUID()
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
    
    func deleteActivity(objectID: NSManagedObjectID) -> Bool {
        guard let activity = getActivity(byObjectID: objectID) else { return false }
        let deleteRequest = NSBatchDeleteRequest(objectIDs: [objectID])
        guard let app = getApp() else { return false }
        do {
            try app.persistentContainer.viewContext.execute(deleteRequest)
        } catch {
            return false
        }
        return true
    }
}
