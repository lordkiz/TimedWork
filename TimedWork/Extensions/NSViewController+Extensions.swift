//
//  NSViewController+Extensions.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 22.11.23.
//

import Cocoa

extension NSViewController {
    func pushIntoView(presentingVC: NSViewController, presentedVC: NSViewController, animator: NSViewControllerPresentationAnimator) {
        NavigationState.shared.add(ViewController: presentedVC)
        presentingVC.present(presentedVC, animator: animator)
    }
    
    func leaveView() {
        dismiss(self)
    }
}
