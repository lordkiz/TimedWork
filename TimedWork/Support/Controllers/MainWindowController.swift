//
//  MainWindowController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.11.23.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    var _toolbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        configureToolbar()
        setUpContent()
        Navigator.shared.toolbarBackButtonDelegate = self
    }
}


extension MainWindowController: NSToolbarDelegate, ToolbarBackButtonDelegate {
    func shouldDisplayBackButton(_ should: Bool) {
        print(should)
        if (should) {
            _toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier.backButtonToolbarIdentifier, at: 0)
        } else {
            _toolbar.removeItem(at: 0)
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
        Navigator.shared.pop()
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if (itemIdentifier == NSToolbarItem.Identifier.backButtonToolbarIdentifier) {
            
            let backButton = NSToolbarItem(itemIdentifier: itemIdentifier)
            backButton.image = NSImage(systemSymbolName: "chevron.backward", accessibilityDescription: "")
            backButton.action = #selector(handleBackButtonPress(_:))
            return backButton
        } else if (itemIdentifier == NSToolbarItem.Identifier.spaceToolbarIdentifier) {
            let space = NSToolbarItem(itemIdentifier: itemIdentifier)
            return space
        }
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
//            NSToolbarItem.Identifier.backButtonToolbarIdentifier
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            NSToolbarItem.Identifier.backButtonToolbarIdentifier,
            NSToolbarItem.Identifier.spaceToolbarIdentifier
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


extension MainWindowController {
    fileprivate func loadPreSetupViewController() {
        guard let vc = storyboard?.instantiateController(withIdentifier: "PreSetupViewController") as? PreSetupViewController
        else {
            return
        }
        contentViewController = vc
    }
    
    fileprivate func loadMainAppViewController() {
        guard let vc = storyboard?.instantiateController(withIdentifier: "MainAppViewController") as? MainAppViewController
        else {
            return
        }
        contentViewController = vc
    }
    
    fileprivate func setUpContent() {
        if (ActivityManager.shared.activities.isEmpty) {
            loadPreSetupViewController()
        } else {
            loadMainAppViewController()
        }
    }
    
    func refresh() {
        setUpContent()
    }
}
