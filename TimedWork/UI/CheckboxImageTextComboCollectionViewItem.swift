//
//  CheckboxImageTextComboCollectionViewItem.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 20.12.23.
//

import Cocoa

class CheckboxImageTextComboCollectionViewItem: NSCollectionViewItem {

    @IBOutlet var titleText: NSTextField!
    
    @IBOutlet var iconImageView: NSImageView!
    
    @IBOutlet var checkBoxItem: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension CheckboxImageTextComboCollectionViewItem {
    static let identifier: NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier(rawValue: "CheckboxImageTextComboCollectionViewItem")
}
