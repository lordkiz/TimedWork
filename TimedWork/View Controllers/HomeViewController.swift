//
//  ViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 18.11.23.
//

import Cocoa

class HomeViewController: NSViewController {

    @IBOutlet var homeContentView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPreSetupViewController()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func addPreSetupViewController() {
        guard let vc = storyboard?.instantiateController(withIdentifier: "PreSetupViewController") as? PreSetupViewController
        else {
            return
        }
        addChild(vc)
        homeContentView.addSubview(vc.view)
        
    }


}

