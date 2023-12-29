//
//  Sidebar.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa


enum SidebarItemObjectType: Int {
    case dashboard,
        activities,
        meetings,
         
        // entities
        activityEntity,
         
        // company
        about,
        terms,
        privacy
}

enum SidebarSection: Int, CustomStringConvertible {
    case main, activity, meeting, company
    var description: String {
        switch self {
        case .company: return "Timed.Work"
        case .main: return "Overview"
        case .activity: return "My Activities"
        case .meeting: return "My Meetings"
        }
    }
}

struct SidebarItem: Hashable {
    let title: String
    let image: NSImage?
    let objectID: NSManagedObjectID?
    let internalID: UUID?
    let objectType: SidebarItemObjectType?
    static func row(title: String, image: NSImage?, objectID: NSManagedObjectID? = nil, objectType: SidebarItemObjectType? = .none, internalID: UUID? = nil) -> Self {
        return SidebarItem(title: title, image: image, objectID: objectID, internalID: internalID, objectType: objectType)
    }
    static func rowWithoutImage(title: String, objectID: NSManagedObjectID? = nil, objectType: SidebarItemObjectType? = .none, internalID: UUID? = nil) -> Self {
        return SidebarItem(title: title, image: nil, objectID: objectID, internalID: internalID, objectType: objectType)
    }
}

class Sidebar: NSObject {
    func computeSections() -> Dictionary<SidebarSection, [SidebarItem]> {
        var result: Dictionary<SidebarSection, [SidebarItem]> = [
            SidebarSection.main: [
                SidebarItem.row(title: "Dashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil), objectType: .dashboard),
                SidebarItem.row(title: "Activities", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil), objectType: .activities),
                SidebarItem.row(title: "Meetings", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil), objectType: .meetings)
            ],
            SidebarSection.company: [
                SidebarItem.rowWithoutImage(title: "About", objectType: .about),
                SidebarItem.rowWithoutImage(title: "Terms & Conditions", objectType: .terms),
                SidebarItem.rowWithoutImage(title: "Privacy", objectType: .privacy),
            ]
        ]
        // Activities
        let myActivities = ActivityManager.shared.activities
        if myActivities.isEmpty {
            result[SidebarSection.activity] = [SidebarItem.rowWithoutImage(title: "No activities")]
        } else {
            result[SidebarSection.activity] = myActivities.map { (activity) in
                return SidebarItem.row(title: activity.name!, image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil), objectID: activity.objectID, objectType: .activityEntity, internalID: activity.internalID)
            }
        }
        
        // Meetings
        result[SidebarSection.meeting] = [SidebarItem.rowWithoutImage(title:"No meetings")]
        return result
    }
}
