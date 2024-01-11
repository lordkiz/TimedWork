//
//  HorizontalLeaderBarsView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 10.01.24.
//

import Cocoa

@IBDesignable
class HorizontalLeaderBarsView: NSView {
    
    // An id that can be set to identify which ChartView is calling the formatterDelegate
    var id: String = "HorizontalLeaderBarsView"
    var formatterDelegate: ChartLabelFormatterDelegate?
    
    var data = [ChartData]() {
        didSet {
            tearDown()
            setNeedsDisplay(bounds)
        }
    }
    
    let viewLayer: CALayer = CALayer()
    
    var textFields: [NSTextField] = []
    
    var imageViews: [NSImageView] = []
    
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
    var barWidth: CGFloat = 40 {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var spaceBetweenBars: CGFloat {
        return 20
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
        forEachBar { bar, startPoint, furthestPoint, endPoint in
            bar.color.set()
            context.move(to: startPoint)
            context.addLine(to: furthestPoint)
            context.addLine(to: CGPointMake(furthestPoint.x, furthestPoint.y - 40))
            context.addLine(to: endPoint)
            context.fillPath()
            
            let imageWidth: CGFloat = 40
            let imageViewRect = CGRect(
                origin: CGPointMake(bounds.maxX - imageWidth , startPoint.y - (barWidth)),
                size: NSSize(
                    width: imageWidth,
                    height: imageWidth
                )
            )
            let imgView = NSImageView(frame: imageViewRect)
            imgView.image = bar.image
            addSubview(imgView)
            imageViews.append(imgView)
            
            let textWidth: CGFloat = 100
            let marginRight: CGFloat = 24
            let textRect = CGRect(
                origin: CGPointMake(bounds.maxX - (textWidth + marginRight), startPoint.y - (barWidth) - imageWidth/4),
                size: NSSize(
                    width: textWidth,
                    height: imageWidth
                )
            )
            let textField = NSTextField(frame: textRect)
            var stringValue = "\(bar.value.rounded())"
            if formatterDelegate != nil {
                stringValue = formatterDelegate!.formatValue(bar.value, id)
            }
            textField.stringValue = stringValue
            textField.drawsBackground = false
            textField.isEditable = false
            textField.isBezeled = false
            textField.alignment = .center
            textField.font = NSFont.systemFont(ofSize: 16)
            
            addSubview(textField)
            textFields.append(textField)
        }
    }
    
    func forEachBar(_ body: (ChartData, _ startPoint: CGPoint, _ furthestPoint: CGPoint, _ endPoint: CGPoint) -> Void) {
        guard let longestValue = data.map({ $0.value }).max() else { return }
        
        var startPoint = CGPointMake(bounds.minX, bounds.maxY - spaceBetweenBars)
        
        for bar in data {
            let ratio = (bar.value/longestValue)
            let furthestPoint = CGPointMake(bounds.maxX * ratio, startPoint.y )
            let endPoint = CGPointMake(startPoint.x, startPoint.y - barWidth)
            defer {
                startPoint = CGPointMake(endPoint.x , endPoint.y - (spaceBetweenBars))
            }
            body(bar, startPoint, furthestPoint, endPoint)
        }
    }
    
    func tearDown() {
        for imageView in imageViews {
            imageView.removeFromSuperview()
        }
        imageViews = []
        for textField in textFields {
            textField.removeFromSuperview()
        }
        textFields = []
    }
    
}
