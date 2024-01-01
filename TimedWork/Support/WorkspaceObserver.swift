//
//  WorkspaceObserver.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 27.12.23.
//

import Cocoa

let names: [NSNotification.Name] = [
    // Activate Application
    NSNotification.Name(rawValue: "NSWorkspaceDidActivateApplicationNotification"),
    // Deactivate Application
    NSNotification.Name(rawValue: "NSWorkspaceDidDeactivateApplicationNotification"),
    // Hide Application
    NSNotification.Name(rawValue: "NSWorkspaceDidHideApplicationNotification"),
    // Terminate application
    NSNotification.Name(rawValue: "NSWorkspaceDidTerminateApplicationNotification"),
    // Device did wake from sleep
    NSNotification.Name(rawValue: "NSWorkspaceDidWakeNotification"),
    // Will power off
    NSNotification.Name(rawValue: "NSWorkspaceWillPowerOffNotification"),
    // Will sleep
    NSNotification.Name(rawValue: "NSWorkspaceWillSleepNotification"),
    // screen will sleep
    NSNotification.Name(rawValue: "NSWorkspaceWScreensDidSleepNotification"),
    // screen Did Wake
    NSNotification.Name(rawValue: "NSWorkspaceWScreensDidWakeNotification")
]

let SECURE_CODING_KEY = "SECURE_CODING_PENDING_REPORTS_KEY"

final class PrefData: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var dict: Dictionary<String, [UUID]>? = [:]
    
    override init() {
        super.init()
    }
    
    init?(coder decoder: NSCoder) {
        dict = decoder.decodeObject(of: [NSDictionary.self, NSArray.self, NSUUID.self, NSString.self], forKey: SECURE_CODING_KEY) as? Dictionary<String, [UUID]> ?? [:]
    }
    
    func encode(with coder: NSCoder) {
        if let data = dict {
            coder.encode(data, forKey: SECURE_CODING_KEY)
        }
    }
}


let PENDING_REPORTS_PREF_KEY = "pendingReports"


class WorkspaceObserver: NSObject {
    override init() {
        super.init()
        for name in names {
            NSWorkspace.shared.notificationCenter.addObserver(
                self,
                selector: #selector(onNotificationReceived(notification:)),
                name: name,
                object: nil
            )
        }
    }
    
    @objc func onNotificationReceived(notification: Notification) {
        switch notification.name {
        //App Activated
        case NSNotification.Name(rawValue: "NSWorkspaceDidActivateApplicationNotification"):
            guard let app = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
            return startRecording(for: app)
        // App deactivated
        case NSNotification.Name(rawValue: "NSWorkspaceDidTerminateApplicationNotification"):
            guard let app = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
            return stopRecording(for: app)
        // App Hidden
        case NSNotification.Name(rawValue: "NSWorkspaceDidHideApplicationNotification"):
            guard let app = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
            return stopRecording(for: app)
        // App closed/killed
        case NSNotification.Name(rawValue: "NSWorkspaceDidDeactivateApplicationNotification"):
            guard let app = notification.userInfo?["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
            return stopRecording(for: app)
        // Device did wake from sleep
        case NSNotification.Name(rawValue: "NSWorkspaceDidWakeNotification"):
            guard let app = NSWorkspace.shared.frontmostApplication else { return stopAllRecording() }
            return startRecording(for: app)
        // Will power off
        case NSNotification.Name(rawValue: "NSWorkspaceWillPowerOffNotification"):
            return stopAllRecording()
        // Will sleep
        case  NSNotification.Name(rawValue: "NSWorkspaceWillSleepNotification"):
            return stopAllRecording()
        // screen will sleep
        case NSNotification.Name(rawValue: "NSWorkspaceWScreensDidSleepNotification"):
            guard let app = NSWorkspace.shared.frontmostApplication else { return stopAllRecording() }
            return stopRecording(for: app)
        // screen Did Wake
        case NSNotification.Name(rawValue: "NSWorkspaceWScreensDidWakeNotification"):
            guard let app = NSWorkspace.shared.frontmostApplication else { return stopAllRecording() }
            return startRecording(for: app)
        default: return
        }
    
    }
    
    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }
    
    private func startRecording(for app: NSRunningApplication) {
        guard let reporter = ReporterManager.shared.fetchReporterBy(appUrl: app.bundleURL?.absoluteString ?? "") else { return
        }
        guard let activities = reporter.activities else { return }
        let values = NSMutableSet()
        
        for activity in activities {
            if let report = ReportManager.shared.createReport(type: .work, startDate:  Date.init(), endDate: nil, reporter: reporter, activity: activity as? Activity) {
                values.add(report.internalID as Any)
            }
        }
        let prefs = UserDefaults.standard
        let obj: Data? = prefs.data(forKey: PENDING_REPORTS_PREF_KEY)
        let decodedDict = decodeDict(data: obj)
        var pending: Dictionary<String, [UUID]> = [:]
        for entry in (decodedDict ?? [:]) {
            pending[entry.key] = entry.value
        }
        
        pending[reporter.appUrl!] = (values.allObjects as! [UUID])
        print("pending \(pending)")
        savePendingRecords(prefs: prefs, pending: pending)
    }
    
    private func stopRecording(for app: NSRunningApplication) {
        guard let reporter = ReporterManager.shared.fetchReporterBy(appUrl: app.bundleURL?.absoluteString ?? "")
            else { return }
        
        let prefs = UserDefaults.standard
        let obj: Data? = prefs.data(forKey: PENDING_REPORTS_PREF_KEY)
        let decodedDict = decodeDict(data: obj)
        if let reportIDs: [UUID] = decodedDict?[reporter.appUrl!] {
            for id in reportIDs {
                if let report = ReportManager.shared.getReport(byID: id) {
                    ReportManager.shared.update(report: report, values: PermittedReportValues(endDate: Date.init(), startDate: nil, type: nil), permitNil: false)
                }
            }
        }
        var pending: Dictionary<String, [UUID]> = [:]
        for entry in (decodedDict ?? [:]) {
            pending[entry.key] = entry.value
        }
        
        pending.removeValue(forKey: reporter.appUrl ?? "")
        savePendingRecords(prefs: prefs, pending: pending)
    }
    
    private func stopAllRecording() {
        if let reports = ReportManager.shared.getAllOpenReports() {
            for report in reports {
                ReportManager.shared.update(report: report, values: PermittedReportValues(endDate: Date.init(), startDate: nil, type: nil))
            }
        }
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: PENDING_REPORTS_PREF_KEY)
        prefs.synchronize()
    }
    
    private func savePendingRecords(prefs: UserDefaults, pending: Dictionary<String, [UUID]>) {
        let prefData = PrefData()
        prefData.dict = pending
        let encodedData = encodeData(data: prefData)
        prefs.set(encodedData, forKey: PENDING_REPORTS_PREF_KEY)
        prefs.synchronize()
    }
}


// MARK: - Utils
extension WorkspaceObserver {
    private func encodeData(data: PrefData) -> Data? {
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
            print("archivedData \(archivedData)")
            return archivedData
        } catch {
            let nserror = error as NSError
            print(nserror)
            return nil
        }
    }
    
    private func decodeDict(data: Data?) -> Dictionary<String, [UUID]>? {
        if data == nil { return nil }
        do {
            let unarchivedData = try NSKeyedUnarchiver.unarchivedObject(ofClass: PrefData.self, from: data!)
            return unarchivedData?.dict
        } catch {
            let nserror = error as NSError
            print(nserror)
            return nil
        }
        
    }
}
