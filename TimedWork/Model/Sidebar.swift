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
    case main, work, company
    var description: String {
        switch self {
        case .company: return "Company"
        case .main: return "Main"
        case .work: return "Work"
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
}

struct RowIdentifier {
    static let dashboard = UUID()
    static let activity = UUID()
    static let meeting = UUID()
}


class Sidebar: NSObject {
    static var sections: Dictionary<SidebarSection, [SidebarItem]> = [
        SidebarSection.main: [
            SidebarItem.row(title: "Dashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil)),
            SidebarItem.row(title: "Work", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil)),
            SidebarItem.row(title: "Meeting", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil))
        ],
        SidebarSection.work: [
            SidebarItem.row(title: "workDashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil)),
            SidebarItem.row(title: "workWork", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil)),
            SidebarItem.row(title: "workMeeting", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil)),
            SidebarItem.row(title: "work2Dashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil)),
            SidebarItem.row(title: "work2Work", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil)),
            SidebarItem.row(title: "work2Meeting", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil))
        ],
        SidebarSection.company: [
            SidebarItem.row(title: "compDashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil)),
            SidebarItem.row(title: "compWork", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil)),
            SidebarItem.row(title: "compMeeting", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil)),
            SidebarItem.row(title: "comp2Dashboard", image: NSImage(systemSymbolName: "speedometer", accessibilityDescription: nil)),
            SidebarItem.row(title: "comp2Work", image: NSImage(systemSymbolName: "laptopcomputer", accessibilityDescription: nil)),
            SidebarItem.row(title: "comp2Meeting", image: NSImage(systemSymbolName: "video.circle", accessibilityDescription: nil))
            
        ],
    ]
}
