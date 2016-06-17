//
//  LineGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/03.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public struct LineGraphViewConfig {
    
    public var lineColor: UIColor
    public var lineWidth: CGFloat
    public var textColor: UIColor
    public var textFont: UIFont
    public var dotEnable: Bool
    public var dotDiameter: CGFloat
    public var contentInsets: UIEdgeInsets
    
    public init(
        lineColor: UIColor? = nil,
        lineWidth: CGFloat? = nil,
        textColor: UIColor? = nil,
        textFont: UIFont? = nil,
        dotEnable: Bool? = nil,
        dotDiameter: CGFloat? = nil,
        contentInsets: UIEdgeInsets? = nil
    ) {
        self.lineColor = lineColor ?? DefaultColorType.Line.color()
        self.lineWidth = lineWidth ?? 3.0
        self.textColor = textColor ?? DefaultColorType.LineText.color()
        self.textFont = textFont ?? UIFont.systemFontOfSize(10.0)
        self.dotEnable = true
        self.dotDiameter = dotDiameter ?? 10.0
        self.contentInsets = contentInsets ?? UIEdgeInsetsZero
    }
}

internal class LineGraphView<T: Hashable, U: NumericType>: UIView {
    
    private var graph: LineGraph<T, U>?
    private var config: LineGraphViewConfig
    
    var lineColor: UIColor? = nil {
        didSet {
            self.config.lineColor = lineColor ?? DefaultColorType.Line.color()
            self.setNeedsDisplay()
        }
    }
    
    init(frame: CGRect, graph: LineGraph<T, U>?) {
        
        self.config = LineGraphViewConfig()
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.graph = graph
    }
    
    func setLineGraphViewConfig(config: LineGraphViewConfig?) {
        self.config = config ?? LineGraphViewConfig()
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let lineGraph = self.graph else { return }
        let rect = self.graphFrame()
        let total = lineGraph.units.map{ $0.value }.reduce(U(0)){ $0 + $1 }
        let sectionWidth = rect.width / CGFloat(lineGraph.units.count)
        let ps = self.points(lineGraph, rect: rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, config.lineColor.CGColor ?? UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, self.config.lineWidth)
        
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
        
        CGContextSetLineWidth(context, 0.0)
        CGContextSetFillColorWithColor(context, config.lineColor.CGColor ?? UIColor.blackColor().CGColor)
        
        if self.config.dotEnable {
            ps.forEach({point in
                let r = CGRect(x: point.x - CGFloat(self.config.dotDiameter / 2.0), y: point.y - CGFloat(self.config.dotDiameter / 2.0), width: CGFloat(self.config.dotDiameter), height: CGFloat(self.config.dotDiameter))
                CGContextStrokeEllipseInRect(context, r)
                CGContextFillEllipseInRect(context, r)
            })
        }
        
        zip(lineGraph.units, ps).forEach { (u, p) in
            
            guard let str = self.graph?.graphTextDisplay()(unit: u, totalValue: total) else {
                return
            }
            
            let attrStr = NSAttributedString.graphAttributedString(str, color: self.config.textColor, font: self.config.textFont)
            
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
    
    private func graphFrame() -> CGRect {
        return CGRect(
            x: self.config.contentInsets.left,
            y: self.config.contentInsets.top,
            width: self.frame.size.width - self.config.contentInsets.horizontalMarginsTotal(),
            height: self.frame.size.height - self.config.contentInsets.verticalMarginsTotal()
        )
    }
    
    private func points(graph: LineGraph<T, U>, rect: CGRect) -> [CGPoint] {
        
        let sectionWidth = rect.width / CGFloat(graph.units.count)
        
        return graph.units.enumerate().map {
            CGPoint(
                x: CGFloat($0) * sectionWidth + (sectionWidth / 2.0) + rect.origin.x,
                y: rect.size.height - rect.size.height * CGFloat(($1.value - graph.range.min).floatValue() / (graph.range.max - graph.range.min).floatValue()) + rect.origin.y
            )
        }
    }
    
}
