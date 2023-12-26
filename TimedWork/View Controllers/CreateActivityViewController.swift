//
//  CreateActivityViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 20.12.23.
//

import Cocoa

class CreateActivityViewController: NSViewController {

    @IBOutlet var enterNameOfActivityLabel: NSTextField!
    @IBOutlet var selectAppsLabel: NSTextField!
    
    @IBOutlet var activityNameTextField: NSTextField!
    
    @IBOutlet var createButton: NSButton!
    
    var theScrollView: NSScrollView!
    
    @IBOutlet var installedAppsCollectionView: NSCollectionView!
    
    let installedApps: [InstalledApp]! = FileSystemOperations.shared.getInstalledApps()
    
    
    var selectedApps: Dictionary<String, InstalledApp> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    
    @IBAction private func onCheckBoxClicked(_ sender: NSButton) {
        let clickedApp = installedApps[sender.tag]
        if (sender.state == .on) {
            selectedApps[clickedApp.appName] = clickedApp
        } else {
            selectedApps.removeValue(forKey: clickedApp.appName)
        }
        installedAppsCollectionView.reloadData()
        if (selectedApps.keys.isEmpty) {
            createButton.isEnabled = false
        } else if !activityNameTextField.stringValue.isEmpty {
            createButton.isEnabled = true
        }
    }
    
    @IBAction private func createActivity(_ sender: NSButton) {
        let created = ActivityManager.shared.createActivity(name: activityNameTextField.stringValue, selectedApps: selectedApps.map { (string, installedApp) in
            return installedApp
        })
        if created {
            NotificationCenter.default.post(name: .activityCreated, object: self)
        }
    }
    
}

extension CreateActivityViewController: NSCollectionViewDelegate {
    private func configureCollectionView() {
//        installedAppsCollectionView = NSCollectionView(frame: NSRect(x: 0, y: 0, width: activityNameTextField.visibleRect.width, height: 300))
        
        installedAppsCollectionView.delegate = self
        installedAppsCollectionView.dataSource = self
        installedAppsCollectionView.isSelectable = true
        installedAppsCollectionView.collectionViewLayout = listLayout()
        installedAppsCollectionView.register(CheckboxImageTextComboCollectionViewItem.self, forItemWithIdentifier: CheckboxImageTextComboCollectionViewItem.identifier)
        
//        theScrollView = NSScrollView(frame: NSRect(x: 0, y: 0, width: activityNameTextField.visibleRect.width, height: 200))
//        theScrollView.documentView = installedAppsCollectionView
//        view.addSubview(theScrollView)
        setUpViews()
        
        installedAppsCollectionView.reloadData()
    }
    
    private func listLayout() -> NSCollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 10, trailing: 5)
        let layout = NSCollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setUpViews() {
        activityNameTextField.delegate = self
        createButton.isEnabled = !activityNameTextField.stringValue.isEmpty
        createButton.action = #selector(createActivity(_:))
        
//        createButton.translatesAutoresizingMaskIntoConstraints = false
//        enterNameOfActivityLabel.translatesAutoresizingMaskIntoConstraints = false
//        activityNameTextField.translatesAutoresizingMaskIntoConstraints = false
//        selectAppsLabel.translatesAutoresizingMaskIntoConstraints = false
//        theScrollView.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addConstraints([
//            enterNameOfActivityLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
//            enterNameOfActivityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
//
//            activityNameTextField.topAnchor.constraint(equalTo: enterNameOfActivityLabel.bottomAnchor, constant: 10),
//            activityNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
//
//            selectAppsLabel.topAnchor.constraint(equalTo: activityNameTextField.bottomAnchor, constant: 20),
//            selectAppsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
//
//            createButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//            createButton.widthAnchor.constraint(equalTo: activityNameTextField.widthAnchor),
//
//            theScrollView.topAnchor.constraint(equalTo: selectAppsLabel.bottomAnchor, constant: 10),
//            theScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 50),
//            theScrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -10),
//            theScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -100),
//            theScrollView.widthAnchor.constraint(equalTo: activityNameTextField.widthAnchor)
//
//        ])
    }
}


extension CreateActivityViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return installedApps.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: CheckboxImageTextComboCollectionViewItem.identifier, for: indexPath) as! CheckboxImageTextComboCollectionViewItem
        let app = installedApps[indexPath.item]
        print(app)
        view.iconImageView.image = app.appIcon
        view.titleText.stringValue = app.appName
        view.checkBoxItem.state = selectedApps[app.appName] == nil ? .off : .on
        view.checkBoxItem.action = #selector(onCheckBoxClicked(_:))
        view.checkBoxItem.tag = indexPath.item
        return view
    }
}

extension CreateActivityViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if activityNameTextField.stringValue.isEmpty {
            createButton.isEnabled = false
        } else if !selectedApps.keys.isEmpty {
            createButton.isEnabled = true
        }
    }
}
