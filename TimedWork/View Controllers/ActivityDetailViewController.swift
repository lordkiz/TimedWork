//
//  ActivityDetailViewController.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 24.12.23.
//

import Cocoa

class ActivityDetailViewController: NSViewController {
    
    var editMode: Bool = false {
        didSet {
            prepareToEditLabel()
        }
    }
    
    var objectID: NSManagedObjectID? = nil
    
    var activityInternalID: UUID? = nil
    
    var activity: Activity? = nil {
        didSet {
            activityNameTextLabel.stringValue = activity?.name ?? ""
            prepareData()
        }
    }
    
    var reporters: [Reporter] = [] {
        didSet {
           for reporter in reporters {
                let imgView = NSImageView(frame: NSMakeRect(0, 0, 90, 90))
                let icon = reporter.getIcon()?.resize(w: 90, h: 90)
                imgView.image = icon
                reportersStackView.addView(imgView, in: .leading)
            }
        }
    }
    
    @IBOutlet var activityNameTextLabel: NSTextField!
    
    @IBOutlet var deleteButton: NSButton!
    
    @IBOutlet var editButton: NSButton!
    
    @IBOutlet var pieChartView: PieChartView!
    
    @IBOutlet var barChartView: BarChartView!
    
    @IBOutlet var editLabelButton: NSButton!
    
    @IBAction func onEditClick(_ sender: NSButton) {
        editMode = true
    }
    
    @IBAction func onSaveClick(_ sender: NSButton) {
        editMode = false
        if activity == nil { return }
        if let savedActivity = ActivityManager.shared.update(activity: activity!, values: PermittedActivityFields(name: activityNameTextLabel.stringValue)) {
            activity = savedActivity
            NotificationCenter.default.post(name: .activityUpdated, object: self)
            return
        }
        // user has entered empty name for activity and we did not update the activity
        activityNameTextLabel.stringValue = activity?.name ?? ""
    }
    
    @IBOutlet var durationSelectButton: NSPopUpButton!
    
    @IBAction func onOneDayClicked(_ sender: NSMenuItem) {
        period = .day
    }
    @IBAction func onOneWeekClicked(_ sender: NSMenuItem) {
        period = .week
    }
    @IBAction func onOneMonthClicked(_ sender: NSMenuItem) {
        period = .month
    }
    @IBAction func onThreeMonthsClicked(_ sender: NSMenuItem) {
        period = .threeMonths
    }
    @IBAction func onSixMonthsClicked(_ sender: NSMenuItem) {
        period = .sixMonths
    }
    @IBAction func onOneYearClicked(_ sender: NSMenuItem) {
        period = .oneYear
    }
    
    @IBOutlet var reportersStackView: NSStackView!
    
    var period: ReportGroupPeriodEnum = .day {
        didSet {
            prepareData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityInternalID != nil {
            activity = ActivityManager.shared.getActivity(byID: activityInternalID!)
            reporters = (activity?.reporters?.allObjects ?? []) as! [Reporter]
        }
        
    }
    
    private func prepareData() {
        if activity != nil {
            let data = ReportManager.shared.getReportsFor(activity: activity!, period: period)
            let barChartData = data.map { groupedReport in
                return ChartData(color: .systemOrange, value: groupedReport.sum())
            }
            barChartView.data = barChartData
            
            var reportersDict: Dictionary<String, Double> = [:]
            
            var reportersAppIconDict: Dictionary<String, NSImage?> = [:]
            
            for groupedReport in data {
                for rep in groupedReport.reports {
                    let report = rep as! Report
                    let reporter = report.reporter
                    reportersDict[reporter?.appName ?? "-"] = reportersDict[reporter?.appName ?? "-"] ?? 0 + (report.endDate?.timeIntervalSince(report.startDate!) ?? 0)
                    if reportersAppIconDict[reporter?.appName ?? ""] == nil {
                        reportersAppIconDict[reporter?.appName ?? ""] = reporter?.getIcon()
                    }
                }
            }
            print(reportersDict)
            let pData: [ChartData] = reportersDict.map { k, v in
                return ChartData(color: reportersAppIconDict[k]??.getColors(quality: .low)?.primary ?? NSColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1), name: k, image: reportersAppIconDict[k] as? NSImage, value: v)
            }
            pieChartView.showImage = true
            pieChartView.imageWidth = 40
            pieChartView.imageHeight = 40
            pieChartView.imagePositionOffset = 0.5
            pieChartView.data = pData
        }
        
    }
    
    private func prepareToEditLabel() {
        if editMode {
            activityNameTextLabel.isEditable = true
            activityNameTextLabel.becomeFirstResponder()
            editLabelButton.action = #selector(onSaveClick(_:))
            editLabelButton.image = NSImage(systemSymbolName: "checkmark", accessibilityDescription: nil)
        } else {
            activityNameTextLabel.isEditable = false
            activityNameTextLabel.resignFirstResponder()
            editLabelButton.action = #selector(onEditClick(_:))
            editLabelButton.image = NSImage(systemSymbolName: "pencil", accessibilityDescription: nil)
            DispatchQueue.main.async {
                guard let window = self.activityNameTextLabel.window else {
                      return
                }
                window.makeFirstResponder(nil)
            }
        }
    }
    
    
    
    @IBAction func deleteActivity(_ sender: NSButton) {
        let deleted = ActivityManager.shared.deleteActivity(objectID: objectID!)
        if deleted {
            Navigator.shared.pop()
            NotificationCenter.default.post(name: .activityDeleted, object: self)
        }
    }
    
}

extension ActivityDetailViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        if activityNameTextLabel.stringValue.isEmpty {
            editLabelButton.isEnabled = false
        } else {
            editLabelButton.isEnabled = true
        }
    }
}
