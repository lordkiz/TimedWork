//
//  ReplacePresentationAnimator.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 21.11.23.
//

import Cocoa

class FadeInAnimator: NSObject, NSViewControllerPresentationAnimator {
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        if let window = fromViewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                fromViewController.view.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                viewController.view.alphaValue = 0
                window.contentViewController = viewController
                viewController.view.animator().alphaValue = 1.0
            })
        }
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        if let window = viewController.view.window {
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                viewController.view.animator().alphaValue = 0
                }, completionHandler: { () -> Void in
                    fromViewController.view.alphaValue = 0
                    window.contentViewController = fromViewController
                    fromViewController.view.animator().alphaValue = 1.0
            })
        }
    }
}
