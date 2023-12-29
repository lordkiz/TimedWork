//
//  PieChartView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 26.12.23.
//

import Cocoa

@IBDesignable
class PieChartView: NSView {
    
    var data = [PieChartData]() {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
       
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    private func forEachSegment(_ body: (PieChartData, _ startAngle: CGFloat, _ endAngle: CGFloat) -> Void) {
        let totalCount = data.lazy.map {$0.value}.reduce(0,+)
        
        // The starting angle is -90 degrees (top of the circle, as the context is
        // flipped). By default, 0 is the right hand side of the circle, with the
        // positive angle being in an anti-clockwise direction (same as a unit
        // circle in maths).
        var startAngle: CGFloat = -.pi * 0.5
        
        for segment in data {
            let endAngle = startAngle + .pi * 2 * (segment.value / totalCount)
            defer {
                startAngle = endAngle
            }
            body(segment, startAngle, endAngle)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let radius = min(frame.width, frame.height) * 0.5
        
        let viewCenter: CGPoint = CGPointMake(NSMidX(bounds), NSMidY(bounds))
        
        forEachSegment { segment, startAngle, endAngle in
            segment.color.set()
            
            context.move(to: viewCenter)
            
            context.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            context.fillPath()
        }
    }
    
}
