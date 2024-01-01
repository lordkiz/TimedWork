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
        NSApplication.shared.addObserver(self, forKeyPath: "effectiveAppearance",options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "effectiveAppearance", let appearance = change?[.newKey] {
            window?.toolbar?.fullScreenAccessoryView?.needsLayout = true
        }
    }

    deinit {
        NSApplication.shared.removeObserver(self)
    }
    
}


extension MainWindowController: NSToolbarDelegate, ToolbarBackButtonDelegate {
    func shouldDisplayBackButton(_ should: Bool) {
        print(should)
        if (should) {
            _toolbar.insertItem(withItemIdentifier: NSToolbarItem.Identifier.backButtonToolbarItemIdentifier, at: 0)
        } else {
            _toolbar.removeItem(at: 0)
        }
    }
    
    
    private func configureToolbar() {
        if let theWindow = self.window {
            let theToolbar = NSToolbar(identifier: NSToolbar.Identifier.mainWindowToolbarIdentifier)
            theToolbar.showsBaselineSeparator = true
            theToolbar.delegate = self
            
            // window config
            theWindow.title = "Timed Work"
            theWindow.titleVisibility = .hidden
            theWindow.toolbar = theToolbar
            theWindow.toolbarStyle = .unified
//            theWindow.titlebarAppearsTransparent = true
//            theWindow.backgroundColor = .blue
            
            _toolbar = theToolbar
        }
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        return getToolbarItem(with: itemIdentifier)
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toggleSidebar,
            .flexibleSpace,
            .addActionToolbarItemIdentifier,
            .sidebarTrackingSeparator,
            .backButtonToolbarItemIdentifier,
            .logoToolbarItemIdentifier
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .backButtonToolbarItemIdentifier,
            .logoToolbarItemIdentifier,
            .settingsToolbarItemIdentifier,
            .addActionToolbarItemIdentifier
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

// MARK: Build toolbar items
extension MainWindowController {
    private func getToolbarItem(with itemIdentifier: NSToolbarItem.Identifier) -> NSToolbarItem? {
        switch itemIdentifier {
        case .backButtonToolbarItemIdentifier:
            return buildBackButton()
        case .addActionToolbarItemIdentifier:
            return buildAddActionButton()
        case .logoToolbarItemIdentifier:
            return buildLogoImage()
        default:
            return nil
        }
    }
    
    private func buildBackButton() -> NSToolbarItem {
        let button = NSToolbarItem(itemIdentifier: .backButtonToolbarItemIdentifier)
        button.image = NSImage(systemSymbolName: "chevron.backward", accessibilityDescription: "")
        button.action = #selector(handleBackButtonPress(_:))
        return button
    }
    
    private func buildAddActionButton() -> NSToolbarItem {
        let button: NSPopUpButton = NSPopUpButton(frame: NSRect(x: 0, y: 0, width: 20, height: 10))
        button.pullsDown = true
        
        button.contentTintColor = NSColor(named: "Primary")
        button.cell?.backgroundStyle = .normal
        let firstItem: NSMenuItem = NSMenuItem()
        let image = NSImage(systemSymbolName: "plus", accessibilityDescription: "")
        let imageConfig = NSImage.SymbolConfiguration(textStyle: .body, scale: .small)
        firstItem.image = image?.withSymbolConfiguration(imageConfig)
        firstItem.title = ""
        
        button.menu?.addItem(firstItem)
        button.menu?.addItem(withTitle: "Add Activity", action: #selector(onAddActivityClicked(_:)), keyEquivalent: "")
        button.menu?.addItem(withTitle: "Sync Meeting", action: nil, keyEquivalent: "")
        let item = NSToolbarItem(itemIdentifier: .addActionToolbarItemIdentifier)
        item.view = button
        return item
    }
    
    private func buildLogoImage() -> NSToolbarItem {
        let item = NSToolbarItem(itemIdentifier: .logoToolbarItemIdentifier)
        let appearance = NSAppearance.currentDrawing().name
        if appearance == .aqua {
            item.image = NSImage(named: "Logo")
        } else {
            item.image = NSImage(named: "LogoWhite")
        }
        return item
    }
    
    @IBAction func handleBackButtonPress(_ sender: Any) {
        Navigator.shared.pop()
    }
    
    @objc private func onAddActivityClicked(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: .toolbarItem, object: nil, userInfo: ["objectType": ToolbarItemType.addActivity]))
    }
}
