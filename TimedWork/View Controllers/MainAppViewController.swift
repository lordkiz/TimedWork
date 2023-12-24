//
//  MainAppViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 09.12.23.
//

import Cocoa

class MainAppViewController: NSSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        splitView.setPosition(100, ofDividerAt: 0)
    }
    
}
