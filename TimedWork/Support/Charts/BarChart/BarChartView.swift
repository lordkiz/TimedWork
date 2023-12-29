//
//  BarChartView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 26.12.23.
//

import Cocoa

@IBDesignable
class BarChartView: NSView {

    var data = [BarChartData]() {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    let viewLayer: CALayer = CALayer()
    
    @IBInspectable
    var horizontal: Bool = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    @IBInspectable
    var borderRadius: Int = 0 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    @IBInspectable
    var animated: Bool = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        forEachBar { bar, startPoint, highestPoint, endPoint in
            bar.color.set()
            print(startPoint)
            print(highestPoint)
            print(endPoint)
            print("------------------")
            context.move(to: startPoint)
            context.addLine(to: highestPoint)
            context.addLine(to: CGPointMake(highestPoint.x + 20, highestPoint.y))
            context.addLine(to: endPoint)
            
            context.fillPath()
        }
    }
    
    func forEachBar(_ body: (BarChartData, _ startPoint: CGPoint, _ highestPoint: CGPoint, _ endPoint: CGPoint) -> Void) {
        guard let tallestValue = data.map({ $0.value }).max() else { return }
        
        var startPoint = CGPointMake(bounds.minX, bounds.minY)
        
        for bar in data {
            let ratio = (bar.value/tallestValue)
            let highestPoint = CGPointMake(startPoint.x, bounds.maxY * ratio)
            let endPoint = CGPointMake(startPoint.x + 20, startPoint.y)
            defer {
                startPoint = endPoint
            }
            body(bar, startPoint, highestPoint, endPoint)
        }
    }
    
}
