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
        setUpButton()
    }
    
    func setUpButton() {
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        getStartedButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        getStartedButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        getStartedButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
    }
    
    
    @IBAction func onGetStartedButtonPressed(_ sender: NSButton) {
        print(sender.title)
    }
}
