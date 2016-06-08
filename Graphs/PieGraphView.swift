//
//  PieGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/07.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

struct PirGraphViewConfig {
    
    var pieColors: [UIColor]?
    
    init(pieColors: [UIColor]? = nil) {
        self.pieColors = pieColors
    }
    
}

public class PieGraphView<T: Hashable, U: NumericType>: UIView {
    
    public typealias PieGraphTextDisplayHandler = (unit: GraphUnit<T, U>, totalValue: U) -> String?

    public var textDisplayHandler: PieGraphTextDisplayHandler?
    
    private var graph: PieGraph<T, U>? {
        didSet {
            self.config.pieColors = DefaultColorType.pieColors(graph?.units.count ?? 0)
            self.setNeedsDisplay()
        }
    }
    private var config: PirGraphViewConfig
    
    public init(frame: CGRect, graph: PieGraph<T, U>?, textDisplayHandler: PieGraphTextDisplayHandler? = nil) {
        
        self.config = PirGraphViewConfig(pieColors: DefaultColorType.pieColors(graph?.units.count ?? 0))
        self.textDisplayHandler = textDisplayHandler
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.graph = graph
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let graph = self.graph else { return }
        
        let values = graph.units.map({ $0.value })
        let total = values.reduce(U(0), combine: { $0 + $1 })
        let percentages = values.map({ Double($0.floatValue() / total.floatValue()) })
        
        let context = UIGraphicsGetCurrentContext();
        let x = self.frame.size.width / 2.0
        let y = self.frame.size.height / 2.0
        let radius = min(x, y) - 10.0
        
        var startAngle = -M_PI / 2.0

        percentages.enumerate().forEach { (index, f) in
            let endAngle = startAngle + M_PI * 2.0 * f
            CGContextMoveToPoint(context, x, y);
            CGContextAddArc(context, x, y, radius, CGFloat(startAngle), CGFloat(endAngle), 0);

            CGContextAddArc(context, x, y, radius/2,  CGFloat(endAngle), CGFloat(startAngle), 1)
            CGContextSetFillColor(context, CGColorGetComponents( self.config.pieColors![index].CGColor ))
            CGContextClosePath(context);
            CGContextFillPath(context);
            startAngle = endAngle
        }
    }
    

}
