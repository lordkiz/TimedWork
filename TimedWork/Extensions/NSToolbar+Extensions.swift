//
//  NSToolbar+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.11.23.
//

import Cocoa

extension NSToolbar.Identifier {
    static let mainWindowToolbarIdentifier = Self("MainWindowToolbar")
}

extension NSToolbarItem.Identifier {
    static let backButtonToolbarItemIdentifier = Self("BackButtonToolbarItemIdentifier")
    static let toogleSidebarToolbarItemIdentifier = Self("ToogleSidebarToolbarItemIdentifier")
    static let logoToolbarItemIdentifier = Self("LogoToolbarItemIdentifier")
    static let settingsToolbarItemIdentifier = Self("SettingsToolbarItemIdentifier")
    static let addActionToolbarItemIdentifier = Self("AddActionToolbarItemIdentifier")
}

enum ToolbarItemType: Int {
    case addActivity
}
