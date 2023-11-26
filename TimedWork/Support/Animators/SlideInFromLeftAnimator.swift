//
//  SlideInFromLeftAnimator.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 21.11.23.
//

import Cocoa

private class BackgroundView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        let appearance = NSAppearance.currentDrawing().name
        if (appearance == .aqua) {
            layer?.backgroundColor = NSColor(white: 150, alpha: 1).cgColor
        } else {
            layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        }
        NSApplication.shared.addObserver(self, forKeyPath: "effectiveAppearance",options: .new, context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "effectiveAppearance", let appearance = change?[.newKey] {
            if ((appearance as! NSAppearance).name == .aqua) {
                layer?.backgroundColor = NSColor(white: 150, alpha: 1).cgColor
            } else {
                layer?.backgroundColor = NSColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            }
        }
    }
    
    fileprivate override func mouseDown(with event: NSEvent) {
        
    }
}

class SlideInFromLeftAnimator: NSObject, NSViewControllerPresentationAnimator {
    private let backgroundView = BackgroundView(frame: CGRectZero)
    private var leftAnchor: NSLayoutConstraint!
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let contentView = fromViewController.view
        backgroundView.frame = contentView.bounds
        backgroundView.autoresizingMask = [.width, .height]
        contentView.addSubview(backgroundView)
        
        let nextView = viewController.view
        nextView.translatesAutoresizingMaskIntoConstraints = false
        leftAnchor = nextView.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 600)
        backgroundView.addSubview(nextView)
        NSLayoutConstraint.activate([
            leftAnchor,
            nextView.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            nextView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            nextView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        
        NSAnimationContext.runAnimationGroup({ context in
            self.backgroundView.animator().alphaValue = 1
            self.leftAnchor.animator().constant = 0
            
        }, completionHandler: nil)
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        NSAnimationContext.runAnimationGroup({ _ in
            self.backgroundView.animator().alphaValue = 0
            self.leftAnchor.animator().constant = 600
        }, completionHandler: {
            self.backgroundView.removeFromSuperview()
        })
    }

}
