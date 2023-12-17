//
//  ActivityManager.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 03.12.23.
//

import Cocoa

class ActivityManager: NSObject {
    static let shared: ActivityManager = ActivityManager()
    
    var appDelegate: AppDelegate!
    var fetchRequest: NSFetchRequest<Activity>!
    
    override init() {
        super.init()
        appDelegate = AppDelegate()
        fetchRequest = Activity.fetchRequest()
    }
    
    var activities: [Activity]  {
        guard let activities = try? appDelegate.persistentContainer.viewContext.fetch(fetchRequest) else { return [] }
        return activities
    }
}
