//
//  ActivityDetailViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 24.12.23.
//

import Cocoa

class ActivityDetailViewController: NSViewController {

    var objectID: NSManagedObjectID? = nil
    var activityInternalID: UUID? = nil
    var activity: Activity? = nil
    
    @IBOutlet var activityNameTextLabel: NSTextField!
    
    @IBOutlet var deleteButton: NSButton!
    
    @IBOutlet var editButton: NSButton!
    
    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if objectID != nil {
//            activity = ActivityManager.shared.getActivity(objectID: objectID!)
//
//        }
        if activityInternalID != nil {
            activity = ActivityManager.shared.getActivity(byID: activityInternalID!)
        }
        setUpUI()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        pieChartView.data = [PieChartData(color: .blue, value: 33), PieChartData(color: .red, value: 24), PieChartData(color: .brown, value: 78), PieChartData(color: .black, value: 33)]
        
        barChartView.data = [BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40),BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40), BarChartData(color: .blue, value: 43), BarChartData(color: .red, value: 24), BarChartData(color: .brown, value: 40), BarChartData(color: .black, value: 40)]
    }
    
    private func setUpUI() {
        activityNameTextLabel.stringValue = activity?.name ?? ""
        NSWorkspace.shared
    }
    
    @IBAction func deleteActivity(_ sender: NSButton) {
        let deleted = ActivityManager.shared.deleteActivity(objectID: objectID!)
        if deleted {
            Navigator.shared.pop()
            NotificationCenter.default.post(name: .activityDeleted, object: self)
        }
    }
    
}
