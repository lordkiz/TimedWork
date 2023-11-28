//
//  SetupItemTableCellView.swift
//  TimedWork
//
//  Created by Kizito Egeonu on 25.11.23.
//

import Cocoa

class SetupItemTableCellView : NSTableCellView {
    
//    static var identifier: String = String(describing: SetupItemTableCellView.self)
    
    @IBOutlet var categoryImage: NSImageView!
    
    @IBOutlet var titleText: NSTextField!
    
    @IBOutlet var descriptionText: NSTextField!
    
    private var mouseOverArea: NSTrackingArea!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mouseOverArea = NSTrackingArea(rect: bounds,options: [NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.mouseEnteredAndExited], owner: self)
        addTrackingArea(mouseOverArea)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
//        NSColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).set()
        NSColor(named: "HoverColor")?.set()
        if highlight {
            let path = NSBezierPath(rect: bounds)
            path.fill()
            NSCursor.pointingHand.set()
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        if !highlight {
            highlight = true
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        if highlight {
            highlight = false
        }
    }
    
    deinit {
        removeTrackingArea(mouseOverArea)
    }
    
    private var highlight = false {
        didSet {
            setNeedsDisplay(bounds)
        }
    }

    
    func updateViews(data: SetupItem) {
        titleText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        categoryImage.translatesAutoresizingMaskIntoConstraints = false
        
        categoryImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        categoryImage.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        categoryImage.image = resize(image: data.image, w: 40, h: 40)
        
        titleText.leftAnchor.constraint(equalTo: categoryImage.rightAnchor, constant: 10).isActive = true
        titleText.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        titleText.stringValue = data.title

        descriptionText.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: 7).isActive = true
        descriptionText.leftAnchor.constraint(equalTo: categoryImage.rightAnchor, constant: 10).isActive = true
        descriptionText.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        descriptionText.stringValue = data.description
        descriptionText.maximumNumberOfLines = 10
        descriptionText.isBordered = false
        
        if (data.isPremium) {
            let isPremiumImageView = NSImageView(frame: NSMakeRect(0, 0, 5, 5))
            let isPImage = NSImage(named: "Premium")
            isPremiumImageView.image = resize(image: isPImage!, w: 10, h: 10)
            addSubview(isPremiumImageView)

            isPremiumImageView.translatesAutoresizingMaskIntoConstraints = false
            isPremiumImageView.leftAnchor.constraint(equalTo: titleText.rightAnchor, constant: 3).isActive = true
            isPremiumImageView.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
        }

        if (!data.images.isEmpty) {
            let appsView = NSStackView(frame: NSMakeRect(0, 0, CGFloat(data.images.count * 15), 20))
            appsView.orientation = .horizontal
            data.images.enumerated().forEach({ index, image in
                if ((image) != nil) {
                    let imgView = NSImageView(frame: NSMakeRect(0, 0, 10, 10))
                    imgView.image = resize(image: image!, w: 12, h: 12)
                    appsView.addView(imgView, in: .top)
                }
            })
            addSubview(appsView)
            appsView.translatesAutoresizingMaskIntoConstraints = false
            appsView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            appsView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
            appsView.centerYAnchor.constraint(equalTo: titleText.centerYAnchor).isActive = true
        }
        
        
    }
    
    func resize(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: .sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
}
