//
//  Navigator.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 23.12.23.
//

import Cocoa

class Navigator: NSObject {
    static let shared: Navigator = Navigator()
    
    override init() {
        super.init()
    }
    
    let _stackedViewControllers: NSMutableArray = []
    var toolbarBackButtonDelegate: ToolbarBackButtonDelegate?
    
    private var previousCount: Int = 0
    private var currentCount: Int = 0
    
    func navigate(from currentVC: NSViewController, to nextVC: NSViewController) {
        previousCount = currentCount
        currentVC.present(nextVC, animator: SlideInFromLeftAnimator())
        _stackedViewControllers.add(nextVC)
        currentCount = _stackedViewControllers.count
        notifyBackButtonDelegate()
    }
    
    func replace(viewController vc: NSViewController, with anotherVC: NSViewController) {
        _stackedViewControllers.replaceObject(at: _stackedViewControllers.count-1, with: anotherVC)
        vc.addChild(anotherVC)
        vc.view.addSubview(anotherVC.view)
    }
    
    func topViewController() -> NSViewController? {
        return _stackedViewControllers.lastObject as! NSViewController?
    }
    
    func pop() {
        if let vc = topViewController() {
            previousCount = currentCount
            _stackedViewControllers.removeObject(at: _stackedViewControllers.count-1)
            vc.dismiss(self)
            currentCount = _stackedViewControllers.count
            notifyBackButtonDelegate()
        }
    }
    
    func canPop() -> Bool {
        _stackedViewControllers.count > 0
    }
    
    private func notifyBackButtonDelegate() {
        if (previousCount == 0 && currentCount == 1) {
            toolbarBackButtonDelegate?.shouldDisplayBackButton(true)
        } else if (previousCount == 1 && currentCount == 0) {
            toolbarBackButtonDelegate?.shouldDisplayBackButton(false)
        }
    }
    
}
