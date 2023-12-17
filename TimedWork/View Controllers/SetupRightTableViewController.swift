//
//  SetupRightTableViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 25.11.23.
//

import Cocoa

class SetupRightViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    private let data = SetupItemData.data
    private var theTableView: NSTableView!
    private let heightOfRow: CGFloat = 120
    private let textField = NSTextField(frame: NSMakeRect(0, 0, 400, 20))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        theTableView = NSTableView(frame: NSMakeRect(0, 0, 400, 370))
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.gridStyleMask = .solidHorizontalGridLineMask
        theTableView.selectionHighlightStyle = .none
        theTableView.focusRingType = .none
        
        let nib = NSNib(nibNamed: "SetupItemTableCellView", bundle: nil)
        theTableView.register(nib, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SetupItemTableCellView"))
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "SetupRightViewColumn"))
        column.width = 400
        theTableView.addTableColumn(column)

        view.addSubview(theTableView)

        theTableView.translatesAutoresizingMaskIntoConstraints = false
        theTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        theTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        theTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        theTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        theTableView.reloadData()

    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return heightOfRow
    }
    
//    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
//        return data[row]
//    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SetupItemTableCellView"), owner: self) as! SetupItemTableCellView
        cellView.updateViews(data: data[row])
        return cellView
    }
    
//    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
//        print(row)
//        let cellView = NSTextField() //SetupItemTableCellView(frame: NSMakeRect(0, 0, 400, 20))
//      cellView.textField!.stringValue = "Row \(row)"
//      cellView.textField!.textColor = .red
//        return cellView as? NSTableRowView
//    }

    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return SetupItemData.data.count
    }
    
}
