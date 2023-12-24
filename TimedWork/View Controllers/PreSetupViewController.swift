//
//  PreSetupViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 19.11.23.
//

import Cocoa

class PreSetupViewController: NSViewController {
    
    weak var pViewController: NSViewController?
    
    @IBOutlet var getStartedButton: NSButton!
    
    @IBOutlet var noActivityTextLabel: NSTextField!
    
    @IBOutlet var configureTextLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pViewController = presentingViewController
        setUpUI()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gooSetupView") {
            if let vc = segue.destinationController as? SetupViewController {
                // pass data
                
            }
        }
    }
    
    
    func setUpUI() {
        // Text Label
        noActivityTextLabel.translatesAutoresizingMaskIntoConstraints = false
        noActivityTextLabel.bottomAnchor.constraint(equalTo: configureTextLabel.topAnchor, constant: -5).isActive = true
        noActivityTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        noActivityTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        configureTextLabel.translatesAutoresizingMaskIntoConstraints = false
        configureTextLabel.bottomAnchor.constraint(equalTo: getStartedButton.topAnchor, constant: -20).isActive = true
        configureTextLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        configureTextLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true        
        
        // Button
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        getStartedButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        getStartedButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        getStartedButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        
        getStartedButton.cell?.backgroundStyle = .raised
    }
    
    
    @IBAction func onButtonPressed(_ sender: NSButton) {
        print(sender.title)
        guard let vc = storyboard?.instantiateController(withIdentifier: "SetupViewController") as? SetupViewController
        else {
            return
        }
        Navigator.shared.navigate(from: self, to: vc)
    }
        
}
