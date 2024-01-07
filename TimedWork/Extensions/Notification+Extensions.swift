//
//  Notification+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 24.12.23.
//

import Cocoa

extension Notification.Name {
    static let sidebarItem = Notification.Name("sidebarItem")
    static let toolbarItem = Notification.Name("toolbarItem")
    static let activityDeleted = Notification.Name("activityDeleted")
    static let activityCreated = Notification.Name("activityCreated")
    static let activityUpdated = Notification.Name("activityUpdated")
}
