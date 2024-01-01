//
//  MainAppContentViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa

class MainAppContentViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppSidebarItemClick(notification:)), name: .sidebarItem, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleToolbarItemClick(notification:)), name: .toolbarItem, object: nil)
    }
    
    @IBAction private func handleAppSidebarItemClick(notification: Notification) {
        switch notification.userInfo?["objectType"] as? SidebarItemObjectType {
        case .activityEntity:
            guard let vc = storyboard?.instantiateController(withIdentifier: "ActivityDetailViewController") as? ActivityDetailViewController else { return }
            vc.objectID = notification.userInfo?["objectID"] as? NSManagedObjectID
            vc.activityInternalID = notification.userInfo?["internalID"] as? UUID
            return Navigator.shared.navigate(from: self, to: vc)
        default:
            return
        }
    }
    
    @IBAction private func handleToolbarItemClick(notification: Notification) {
        switch notification.userInfo?["objectType"] as? ToolbarItemType {
        case .addActivity:
            guard let vc = storyboard?.instantiateController(withIdentifier: "CreateActivityViewController") as? CreateActivityViewController else { return }
            return Navigator.shared.navigate(from: self, to: vc)
        default:
            return
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
