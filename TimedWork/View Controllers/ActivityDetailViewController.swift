//
//  ActivityDetailViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 24.12.23.
//

import Cocoa

class ActivityDetailViewController: NSViewController {

    var objectID: NSManagedObjectID? = nil
    var activity: Activity? = nil
    
    @IBOutlet var activityNameTextLabel: NSTextField!
    
    @IBOutlet var deleteButton: NSButton!
    
    @IBOutlet var editButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if objectID != nil {
            activity = ActivityManager.shared.getActivity(objectID: objectID!)
            
        }
        setUpUI()
    }
    
    private func setUpUI() {
        activityNameTextLabel.stringValue = activity?.name ?? ""
    }
    
    @IBAction func deleteActivity(_ sender: NSButton) {
        let deleted = ActivityManager.shared.deleteActivity(objectID: objectID!)
        if deleted {
            Navigator.shared.pop()
            NotificationCenter.default.post(name: .activityDeleted, object: self)
        }
    }
    
}
