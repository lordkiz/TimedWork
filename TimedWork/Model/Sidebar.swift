//
//  Sidebar.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa

enum SidebarItemType: Int {
    case header, expandableRow, row
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

struct SidebarItem: Hashable, Identifiable {
    let id: UUID
    let type: SidebarItemType
    let title: String
    let image: NSImage?
    static func header(title: String, id: UUID = UUID()) -> Self {
        return SidebarItem(id: id, type: .header, title: title, image: nil)
    }
    static func expandableRow(title: String, image: NSImage?, id: UUID = UUID()) -> Self {
        return SidebarItem(id: id, type: .expandableRow, title: title, image: image)
    }
    static func row(title: String, image: NSImage?, id: UUID = UUID()) -> Self {
        return SidebarItem(id: id, type: .row, title: title, image: image)
    }
    static func rowWithoutImage(title: String, id: UUID = UUID()) -> Self {
        return SidebarItem(id: id, type: .row, title: title, image: nil)
    }
}

struct RowIdentifier {
    static let dashboard = UUID()
    static let activity = UUID()
    static let meeting = UUID()
}


class Sidebar: NSObject {
    func computeSections() -> Dictionary<SidebarSection, [SidebarItem]> {
        var result: Dictionary<SidebarSection, [SidebarItem]> = [
            SidebarSection.main: [
                SidebarItem.row(title: "Dashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil)),
                SidebarItem.row(title: "Activities", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil)),
                SidebarItem.row(title: "Meetings", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil))
            ],
            SidebarSection.company: [
                SidebarItem.rowWithoutImage(title: "About"),
                SidebarItem.rowWithoutImage(title: "Terms & Conditions"),
                SidebarItem.rowWithoutImage(title: "Privacy"),
            ]
        ]
        // Activities
        let myActivities = ActivityManager.shared.activities
        if myActivities.isEmpty {
            result[SidebarSection.activity] = [SidebarItem.rowWithoutImage(title: "No activities")]
        } else {
            result[SidebarSection.activity] = myActivities.map { (activity) in
                return SidebarItem.row(title: activity.name!, image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil))
            }
        }
        
        // Meetings
        result[SidebarSection.meeting] = [SidebarItem.rowWithoutImage(title:"No meetings")]
        return result
    }
}
