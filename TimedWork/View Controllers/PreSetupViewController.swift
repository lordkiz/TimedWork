//
//  PreSetupViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 19.11.23.
//

import Cocoa

class PreSetupViewController: NSViewController {
    
    @IBOutlet var getStartedButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func onGetStartedButtonPressed(_ sender: NSButton) {
        print(sender.title)
    }
}
