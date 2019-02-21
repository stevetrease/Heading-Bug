//
//  Compass.swift
//  Heading Bug
//
//  Created by Steve on 19/02/2019.
//  Copyright © 2019 Steve. All rights reserved.
//

import Foundation
import UIKit



@IBDesignable  class CompassView: UIView {
    
    @IBInspectable var heading = 0.0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private let lineWeight = 2.0
    private var radius = 1.0
    
    
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
        
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)")
    }
    
    override func draw(_ rect:CGRect) {
        print (NSURL (fileURLWithPath: "\(#file)").lastPathComponent!, "\(#function)", heading)

        radius = Double((0.9 * min(rect.width, rect.height)) / 2)
        let center = CGPoint (x: rect.width / 2, y: rect.height / 2)
        
        // draw clock face
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addArc(center: center, radius: CGFloat(radius), startAngle: CGFloat(0), endAngle: CGFloat(2 * Double.pi), clockwise: true)
        ctx?.setFillColor(UIColor.clear.cgColor)
        ctx?.setStrokeColor(UIColor.lightGray.cgColor)
        ctx?.setLineWidth(CGFloat(lineWeight * 2))
        ctx?.drawPath(using: .fillStroke)
        
        let lines = 8
        for line in 1...lines {
            ctx?.saveGState()
            ctx?.translateBy(x: center.x, y: center.y)
            ctx?.rotate(by: CGFloat ((2 * Double.pi) * (Double(line) / Double(lines))))
            ctx?.addLines(between: [CGPoint(x: CGFloat(0), y:CGFloat(0)), CGPoint(x: CGFloat(0), y: CGFloat(radius))])
            ctx?.setLineWidth(CGFloat(lineWeight / 2))
            ctx?.drawPath(using: .fillStroke)
            ctx?.restoreGState()
        }
        
        let ticks = 16
        for tick in 1...ticks {
            ctx?.saveGState()
            ctx?.translateBy(x: center.x, y: center.y)
            ctx?.rotate(by: CGFloat ((2 * Double.pi) * (Double(tick) / Double(ticks))))
            ctx?.addLines(between: [CGPoint(x: CGFloat(0), y:CGFloat(radius - (lineWeight * 3))), CGPoint(x: CGFloat(0), y: CGFloat(radius))])
            ctx?.setLineWidth(CGFloat(lineWeight))
            ctx?.drawPath(using: .fillStroke)
            ctx?.restoreGState()
        }
        
        
        // Draw the needle
        let rotation =  ((heading - 180) / 360) * (Double.pi * 2)
        ctx?.setStrokeColor(UIColor.black.cgColor)
        ctx?.saveGState()
        ctx?.translateBy(x: center.x, y: center.y)
        ctx?.rotate(by: CGFloat (rotation))
        ctx?.addLines(between: [CGPoint(x: CGFloat(0), y:CGFloat(radius - (lineWeight * 5))), CGPoint(x: CGFloat(0), y: CGFloat(radius))])
        ctx?.setLineWidth(CGFloat(lineWeight * 3))
        ctx?.drawPath(using: .fillStroke)
        ctx?.restoreGState()
    }

}
