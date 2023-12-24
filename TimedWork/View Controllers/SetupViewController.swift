//
//  SetupViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 21.11.23.
//

import Cocoa

class SetupViewController: NSSplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitView.setPosition(100, ofDividerAt: 0)
    }
    
}
