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
    
    @IBInspectable
    var barWidth: CGFloat = 20 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var spaceBetweenBars: CGFloat {
        return ((bounds.width/CGFloat(data.count)) - barWidth) / 2
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
        
        forEachHorizontalLine { startPoint, endPoint in
            print(startPoint)
            context.setStrokeColor(.init(red: 169/255, green: 169/255, blue: 169/255, alpha: 0.5))
            context.setLineWidth(1)
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.drawPath(using: .fillStroke)
        }
        
        forEachVerticalLinefunc { startPoint, endPoint in
            context.setStrokeColor(.init(red: 169/255, green: 169/255, blue: 169/255, alpha: 0.5))
            context.setLineWidth(1)
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.drawPath(using: .fillStroke)
        }
        
        forEachBar { bar, startPoint, highestPoint, endPoint in
            bar.color.set()
            context.move(to: startPoint)
            context.addLine(to: highestPoint)
            context.addLine(to: CGPointMake(highestPoint.x + 20, highestPoint.y))
            context.addLine(to: endPoint)
            context.fillPath()
        }
        
    }
    
    func forEachBar(_ body: (BarChartData, _ startPoint: CGPoint, _ highestPoint: CGPoint, _ endPoint: CGPoint) -> Void) {
        guard let tallestValue = data.map({ $0.value }).max() else { return }
        
        var startPoint = CGPointMake(bounds.minX + spaceBetweenBars, bounds.minY)
        
        for bar in data {
            print("Bar \(bar)")
            let ratio = (bar.value/tallestValue)
            let highestPoint = CGPointMake(startPoint.x, bounds.maxY * ratio)
            let endPoint = CGPointMake(startPoint.x + barWidth, startPoint.y)
            defer {
                startPoint = CGPointMake(endPoint.x + (spaceBetweenBars * 2), endPoint.y)
            }
            body(bar, startPoint, highestPoint, endPoint)
        }
    }
    
    func forEachHorizontalLine(_ body: (_ startPoint: CGPoint, _ endPoint: CGPoint) -> Void) {
        let tallestValue = max(data.map({ $0.value }).max() ?? 0, bounds.height)
        let spaces = stride(from: 0, through: tallestValue, by: tallestValue/5)
        var startPoint = CGPointMake(bounds.minX, bounds.minY)
        for value in spaces {
            let endPoint = CGPointMake(bounds.maxX, startPoint.y)
            defer {
                startPoint = CGPointMake(startPoint.x, value)
            }
            body(startPoint, endPoint)
        }
    }
    
    func forEachVerticalLinefunc(_ body: (_ startPoint: CGPoint, _ endPoint: CGPoint) -> Void) {
        if data.count == 0 { return }
        let width = bounds.width/CGFloat(data.count)
        var startPoint = CGPointMake(bounds.minX, bounds.maxY)
        var endPoint = CGPointMake(bounds.minX, bounds.minY)
        for _ in stride(from: 0, through: bounds.width, by: width) {
            defer {
                endPoint = CGPointMake(startPoint.x + width, bounds.minY)
                startPoint = CGPointMake(endPoint.x, bounds.maxY)
            }
            body(startPoint, endPoint)
        }
    }
    
}
