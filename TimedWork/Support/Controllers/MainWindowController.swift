//
//  MainWindowController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.11.23.
//

import Cocoa

class MainWindowController: NSWindowController, NSToolbarDelegate {
    
    var _toolbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        configureToolbar()
        NavigationState.shared.addObserver(self, forKeyPath: "count", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "count", let count = change?[.newKey] {
            let theToolbar = NSToolbar(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
            if ((count as! Int) > 0) {
                _toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier.backButtonToolbarIdentifier, at: 0)
            } else {
                _toolbar.removeItem(at: 0)
            }
            
        }
    }
    
    private func configureToolbar() {
        if let theWindow = self.window {
            let theToolbar = NSToolbar(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
            theToolbar.delegate = self
            
            // window config
            theWindow.title = "Timed Work"
            theWindow.titleVisibility = .hidden
            theWindow.toolbar = theToolbar
            
            _toolbar = theToolbar
        }
    }
    
    @IBAction func handleBackButtonPress(_ sender: Any) {
        if (NavigationState.shared.count < 1) {
            return
        }
        if let vc = NavigationState.shared.pop() {
            vc.leaveView()
        }
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if (itemIdentifier == NSToolbarItem.Identifier.backButtonToolbarIdentifier) {
            if NavigationState.shared.count < 1 {
                return nil
            }
            let backButton = NSToolbarItem(itemIdentifier: itemIdentifier)
            backButton.image = NSImage(systemSymbolName: "chevron.backward", accessibilityDescription: "")
            backButton.action = #selector(handleBackButtonPress(_:))
            return backButton
        } else if (itemIdentifier == NSToolbarItem.Identifier.spaceToolbarIdentifier) {
            let space = NSToolbarItem(itemIdentifier: itemIdentifier)
            
        }
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.backButtonToolbarIdentifier
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.backButtonToolbarIdentifier
        ]
    }

    func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        // Return the identifiers you'd like to show as "selected" when clicked.
                // Similar to how they look in typical Preferences windows.
        return []
    }

    func toolbarWillAddItem(_ notification: Notification) {
        print("toolbarWillAddItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
    }

    func toolbarDidRemoveItem(_ notification: Notification) {
        print("toolbarDidRemoveItem", (notification.userInfo?["item"] as? NSToolbarItem)?.itemIdentifier ?? "")
    }
    
}
