//
//  SidebarCollectionViewItem.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa

class SidebarCollectionViewItem: NSCollectionViewItem {

    @IBOutlet var titleText: NSTextField!
    
    
    @IBOutlet var itemImageView: NSImageView!
    
    var objectID: NSManagedObjectID?
    var objectType: SidebarItemObjectType?
    var internalID: UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleText.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleText.leftAnchor.constraint(equalTo: itemImageView.rightAnchor, constant: 5).isActive = true
        titleText.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        itemImageView.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        NotificationCenter.default.post(name: .sidebarItem,object: self, userInfo: ["objectID": objectID, "objectType": objectType, "internalID": internalID] as Dictionary<String, Any?> as [AnyHashable : Any])
    }

    
    func updateViews(data: SidebarItem) {
        titleText.stringValue = data.title
        if (data.image != nil) {
            itemImageView.image = data.image
        }
        objectID = data.objectID
        objectType = data.objectType
        internalID = data.internalID
    }
}

extension SidebarCollectionViewItem {
    static let identifier = NSUserInterfaceItemIdentifier(rawValue: "SidebarCollectionViewItem")
}
