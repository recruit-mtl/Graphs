//
//  PieGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/07.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public struct PieGraphViewConfig {
    
    public var pieColors: [UIColor]?
    public var textColor: UIColor
    public var textFont: UIFont
    public var isDounut: Bool
    public var contentInsets: UIEdgeInsets
    
    public init(
        pieColors: [UIColor]? = nil,
        textColor: UIColor? = nil,
        textFont: UIFont? = nil,
        isDounut: Bool = false,
        contentInsets: UIEdgeInsets? = nil
    ) {
        self.pieColors = pieColors
        self.textColor = textColor ?? DefaultColorType.PieText.color()
        self.textFont = textFont ?? UIFont.systemFontOfSize(10.0)
        self.isDounut = isDounut
        self.contentInsets = contentInsets ?? UIEdgeInsetsZero
    }
    
}

internal class PieGraphView<T: Hashable, U: NumericType>: UIView {
    
    private var graph: PieGraph<T, U>? {
        didSet {
            self.config.pieColors = DefaultColorType.pieColors(graph?.units.count ?? 0)
            self.setNeedsDisplay()
        }
    }
    private var config: PieGraphViewConfig
    
    init(frame: CGRect, graph: PieGraph<T, U>?) {
        
        self.config = PieGraphViewConfig(pieColors: DefaultColorType.pieColors(graph?.units.count ?? 0))
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.graph = graph
    }
    
    func setPieGraphViewConfig(config: PieGraphViewConfig?) {
        self.config = config ?? PieGraphViewConfig()
        self.setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let graph = self.graph else { return }
        
        func convert<S: NumericType>(s: S, arr: [S], f: (S) -> S) -> [S] {
            switch arr.match {
            case let .Some(h, t):   return [f(h) + s] + convert(h + s, arr:t, f: f)
            case .None:             return []
            }
        }
        
        let colors = self.config.pieColors ?? DefaultColorType.pieColors(graph.units.count)
        
        let values = graph.units.map({ max($0.value, U(0)) })
        let total = values.reduce(U(0), combine: { $0 + $1 })
        let percentages = values.map({ Double($0.floatValue() / total.floatValue()) })
        
        let rect = self.graphFrame()
        
        let context = UIGraphicsGetCurrentContext();
        let x = rect.size.width / 2.0 + rect.origin.x
        let y = rect.size.height / 2.0 + rect.origin.y
        let radius = min(rect.width, rect.height) / 2.0
        
        let centers = convert(0.0, arr: percentages) { $0 / 2.0 }.map { (c) -> CGPoint in
            let angle = M_PI * 2.0 * c - M_PI / 2.0
            return CGPoint(
                x: Double(x) + cos(angle) * Double(radius * 3.0 / 4.0),
                y: Double(y) + sin(angle) * Double(radius * 3.0 / 4.0)
            )
        }
        
        var startAngle = -M_PI / 2.0

        percentages.enumerate().forEach { (index, f) in
            let endAngle = startAngle + M_PI * 2.0 * f
            CGContextMoveToPoint(context, x, y);
            CGContextAddArc(context, x, y, radius, CGFloat(startAngle), CGFloat(endAngle), 0);

            if self.config.isDounut {
                CGContextAddArc(context, x, y, radius/2,  CGFloat(endAngle), CGFloat(startAngle), 1)
            }
            
            CGContextSetFillColor(context, CGColorGetComponents( colors[index].CGColor ))
            CGContextClosePath(context);
            CGContextFillPath(context);
            startAngle = endAngle
        }
        
        zip(graph.units, centers).forEach { (u, center) in
            
            guard let str = self.graph?.graphTextDisplay()(unit: u, totalValue: total) else {
                return
            }
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .Center
            
            let attrStr = NSAttributedString(string: str, attributes: [
                NSForegroundColorAttributeName:self.config.textColor,
                NSFontAttributeName: UIFont.systemFontOfSize(10.0),
                NSParagraphStyleAttributeName: paragraph
            ])
            
            let size = attrStr.size()
            
            attrStr.drawInRect(
                CGRect(
                    origin: CGPoint(
                        x: center.x - size.width / 2.0,
                        y: center.y - size.height / 2.0
                    ),
                    size: size
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

}
