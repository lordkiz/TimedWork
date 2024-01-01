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
    var activity: Activity? = nil {
        didSet {
            prepareData()
        }
    }
    
    @IBOutlet var activityNameTextLabel: NSTextField!
    
    @IBOutlet var deleteButton: NSButton!
    
    @IBOutlet var editButton: NSButton!
    
    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var barChartView: BarChartView!
    
    var barChartData: [BarChartData] = [] {
        didSet {
            barChartView.data = barChartData
            view.setNeedsDisplay(view.bounds)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityInternalID != nil {
            activity = ActivityManager.shared.getActivity(byID: activityInternalID!)
        }
        setUpUI()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        pieChartView.data = [PieChartData(color: .blue, value: 33), PieChartData(color: .red, value: 24), PieChartData(color: .brown, value: 78), PieChartData(color: .black, value: 33)]
    }
    
    private func prepareData() {
        if activity != nil {
            let data = ReportManager.shared.getReportsFor(activity: activity!, period: .week)
            let barChartData = data.map { groupedReport in
                return BarChartData(color: .systemOrange, value: groupedReport.sum())
            }
            barChartView.data = barChartData
        }
        
    }
    
    private func setUpUI() {
        activityNameTextLabel.stringValue = activity?.name ?? ""
    }
    
    @IBAction func deleteActivity(_ sender: NSButton) {
        let deleted = ActivityManager.shared.deleteActivity(objectID: objectID!)
        if deleted {
            Navigator.shared.pop()
            NotificationCenter.default.post(name: .activityDeleted, object: self)
        }
    }
    
}
