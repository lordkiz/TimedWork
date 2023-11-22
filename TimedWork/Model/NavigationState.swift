//
//  NavigationState.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.11.23.
//

import Cocoa

class NavigationState: NSObject {
    static let shared = NavigationState()
    
    let _stackedViewController: NSMutableArray = []
    @objc dynamic var count: Int = 0
    
    override init() {
        super.init()
    }
    
    func topViewController() -> NSViewController? {
        return _stackedViewController.lastObject as! NSViewController?
    }
    
    func add(ViewController vc: NSViewController) {
        _stackedViewController.add(vc)
        count = _stackedViewController.count
    }
    
    func pop() -> NSViewController? {
        let vc = topViewController()
        _stackedViewController.removeObject(at: _stackedViewController.count-1)
        count = _stackedViewController.count
        return vc
    }
}
