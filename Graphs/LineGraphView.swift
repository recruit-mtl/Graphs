//
//  LineGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/03.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

struct LineGraphViewConfig {
    
    var lineColor: UIColor
    var textColor: UIColor
    var dotEnable: Bool
    var dotDiameter: CGFloat
    var sectionWidth: CGFloat?
    
    init(
        lineColor: UIColor? = nil,
        textColor: UIColor? = nil,
        dotEnable: Bool? = nil,
        dotDiameter: CGFloat? = nil,
        sectionWidth: CGFloat? = nil
        ) {
        self.lineColor = lineColor ?? DefaultColorType.Line.color()
        self.textColor = textColor ?? DefaultColorType.LineText.color()
        self.dotEnable = true
        self.dotDiameter = dotDiameter ?? 10.0
        self.sectionWidth = sectionWidth
    }
}

public class LineGraphView<T: Hashable, U: NumericType>: UIView {
    
    public typealias LineGraphTextDisplayHandler = (GraphUnit<T, U>) -> String?
    
    public var textDisplayHandler: ((GraphUnit<T, U>) -> String?)?
    
    private var graph: LineGraph<T, U>?
    private var config: LineGraphViewConfig
    
    public var lineColor: UIColor? = nil {
        didSet {
            self.config.lineColor = lineColor ?? DefaultColorType.Line.color()
            self.setNeedsDisplay()
        }
    }
    
    
    public init(frame: CGRect, graph: LineGraph<T, U>?, textDisplayHandler: LineGraphTextDisplayHandler? = nil) {
        
        self.config = LineGraphViewConfig()
        self.textDisplayHandler = textDisplayHandler
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.graph = graph
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let lineGraph = self.graph else { return }
        
        let ps = self.points(lineGraph, sectionWidth: self.config.sectionWidth)
        
        let textColor = self.config.textColor
        
        let sectionWidth = self.config.sectionWidth ?? (self.frame.size.width / CGFloat(lineGraph.units.count))
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, config.lineColor.CGColor ?? UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, 3.0)
        
        ps.forEach({point in
            if point == ps.first {
                CGContextMoveToPoint(context, point.x, point.y)
            }
            else {
                CGContextAddLineToPoint(context, point.x, point.y)
                CGContextStrokePath(context)
                CGContextMoveToPoint(context, point.x, point.y)
            }
        })
        
        CGContextSetFillColorWithColor(context, config.lineColor.CGColor ?? UIColor.blackColor().CGColor)
        
        if self.config.dotEnable {
            ps.forEach({point in
                let r = CGRect(x: point.x - CGFloat(self.config.dotDiameter / 2.0), y: point.y - CGFloat(self.config.dotDiameter / 2.0), width: CGFloat(self.config.dotDiameter), height: CGFloat(self.config.dotDiameter))
                CGContextStrokeEllipseInRect(context, r)
                CGContextFillEllipseInRect(context, r)
            })
        }
        
        zip(lineGraph.units, ps).forEach { (u, p) in
            
            guard let str = self.textDisplayHandler?(u) else {
                return
            }
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .Center
            
            let attrStr = NSAttributedString(string: str, attributes: [
                NSForegroundColorAttributeName:textColor,
                NSFontAttributeName: UIFont.systemFontOfSize(10.0),
                NSParagraphStyleAttributeName: paragraph
                ])
            
            let size = attrStr.size()
            
            attrStr.drawInRect(
                CGRect(
                    origin: CGPoint(
                        x: p.x - sectionWidth / 2.0,
                        y: u.value >= U(0)
                            ? p.y - size.height - 3.0 - self.config.dotDiameter / 2.0
                            : p.y + 3.0 + self.config.dotDiameter / 2.0
                    ),
                    size: CGSize(
                        width: sectionWidth,
                        height: size.height
                    )
                )
            )
        }
    }
    
    private func points(graph: LineGraph<T, U>, sectionWidth: CGFloat?) -> [CGPoint] {
        
        let interval = sectionWidth ?? (self.frame.width / CGFloat(graph.units.count))
        
        return graph.units.enumerate().map {
            CGPoint(
                x: CGFloat($0) * interval + (interval / 2.0),
                y: self.frame.size.height - self.frame.size.height * CGFloat(($1.value - graph.range.min).floatValue() / (graph.range.max - graph.range.min).floatValue())
            )
        }
    }
    
}
