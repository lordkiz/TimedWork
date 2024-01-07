//
//  PieChartView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 26.12.23.
//

import Cocoa

@IBDesignable
class PieChartView: NSView {
    
    var data = [ChartData]() {
        didSet {
            setNeedsDisplay(self.bounds)
        }
    }
    
    var showText: Bool = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var showImage: Bool = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var imageWidth: Double = 50 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var imageHeight: Double = 50 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var textPositionOffset: CGFloat = 0.67 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var imagePositionOffset: CGFloat = 0.67 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var font: NSFont = NSFont.systemFont(ofSize: 14) {
        didSet { setNeedsDisplay(bounds) }
    }

    private let paragraphStyle: NSParagraphStyle = {
        var p = NSMutableParagraphStyle()
        p.alignment = .center
        return p.copy() as! NSParagraphStyle
    }()

    private lazy var textAttributes: [NSAttributedString.Key: Any] = [
        .paragraphStyle: self.paragraphStyle, .font: font
    ]
    
    var labelFormatter = LabelFormatter.nameWithValue {
        didSet { setNeedsDisplay(bounds) }
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
    
    private func forEachSegment(_ body: (ChartData, _ startAngle: CGFloat, _ endAngle: CGFloat) -> Void) {
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
        for view in subviews{
            view.removeFromSuperview()
        }
        super.draw(dirtyRect)
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        
        let radius = min(frame.width, frame.height) * 0.5
        
        let viewCenter: CGPoint = CGPointMake(NSMidX(bounds), NSMidY(bounds))
        
        // the chart data with the highest value
        let maxData = data.max(by: {a, b in
            a.value < b.value
        })
        
        forEachSegment { segment, startAngle, endAngle in
            segment.color.set()
            
            context.move(to: viewCenter)
            
            context.addArc(center: viewCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            
            context.fillPath()
        }
        
        if showText {
            forEachSegment { segment, startAngle, endAngle in
                // Get the angle midpoint.
                let halfAngle = startAngle + (endAngle - startAngle) * 0.5;
                
                // Get the 'center' of the segment.
                var segmentCenter = viewCenter
                
                if data.count > 1 {
                    segmentCenter = segmentCenter.projected(by: radius * textPositionOffset, angle: halfAngle)
                }
                
                // Text to render – the segment value is formatted to 1dp if needed to
                // be displayed.
                let textToRender = labelFormatter.getLabel(for: segment) as NSString
                
                let brightness = (segment.color.redComponent + segment.color.greenComponent + segment.color.blueComponent) / 3
                
                // If too light, use black. If too dark, use white.
                textAttributes[.foregroundColor] =
                brightness > 0.4 ? NSColor.black : NSColor.white
                
                let textRenderSize = textToRender.size(withAttributes: textAttributes)
                
                // The bounds that the text will occupy.
                let renderRect = CGRect(
                    origin: segmentCenter, size: textRenderSize
                )
                
                // Draw text in the rect, with the given attributes.
                textToRender.draw(in: renderRect, withAttributes: textAttributes)
            }
        }
        
        if showImage {
            forEachSegment { segment, startAngle, endAngle in
                // Get the angle midpoint.
                let halfAngle = startAngle + (endAngle - startAngle) * 0.5;
                
                // Get the 'center' of the segment.
                var segmentCenter = viewCenter
                
                if data.count > 1 {
                    segmentCenter = segmentCenter.projected(by: radius * imagePositionOffset, angle: halfAngle)
                }
                
                // let pad the scale factor
                let scalePadding = ((maxData?.value ?? segment.value) - segment.value) * 0.5
                
                let scaleFactor = ((segment.value + scalePadding) / (maxData?.value ?? segment.value))
                
                // We need to account for the image size in order to account for the true center of the image
                let imageViewRect = CGRect(
                    origin: CGPointMake(segmentCenter.x - (imageWidth * scaleFactor * imagePositionOffset), segmentCenter.y - (imageHeight * scaleFactor * imagePositionOffset)),
                    size: NSSize(
                        width: imageWidth * scaleFactor ,
                        height: imageHeight * scaleFactor
                    )
                )
                
                let imageView = NSImageView(frame: imageViewRect)
                
                if let image = segment.image {
                    imageView.image = image.resize(w: imageWidth * scaleFactor, h: imageWidth * scaleFactor)
                    addSubview(imageView)
                }
            }
        }
    }
    
}
