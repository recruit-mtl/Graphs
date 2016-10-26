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
        self.lineColor = lineColor ?? DefaultColorType.line.color()
        self.lineWidth = lineWidth ?? 3.0
        self.textColor = textColor ?? DefaultColorType.lineText.color()
        self.textFont = textFont ?? UIFont.systemFont(ofSize: 10.0)
        self.dotEnable = true
        self.dotDiameter = dotDiameter ?? 10.0
        self.contentInsets = contentInsets ?? UIEdgeInsets.zero
    }
}

internal class LineGraphView<T: Hashable, U: NumericType>: UIView {
    
    fileprivate var graph: LineGraph<T, U>?
    fileprivate var config: LineGraphViewConfig
    
    var lineColor: UIColor? = nil {
        didSet {
            self.config.lineColor = lineColor ?? DefaultColorType.line.color()
            self.setNeedsDisplay()
        }
    }
    
    init(frame: CGRect, graph: LineGraph<T, U>?) {
        
        self.config = LineGraphViewConfig()
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.graph = graph
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLineGraphViewConfig(_ config: LineGraphViewConfig?) {
        self.config = config ?? LineGraphViewConfig()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let lineGraph = self.graph else { return }
        let rect = self.graphFrame()
        let total = lineGraph.units.map{ $0.value }.reduce(U(0)){ $0 + $1 }
        let sectionWidth = rect.width / CGFloat(lineGraph.units.count)
        let ps = self.points(lineGraph, rect: rect)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(config.lineColor.cgColor )
        context?.setLineWidth(self.config.lineWidth)
        
        ps.forEach({point in
            if point == ps.first {
                context?.move(to: CGPoint(x: point.x, y: point.y))
            }
            else {
                context?.addLine(to: CGPoint(x: point.x, y: point.y))
                context?.strokePath()
                context?.move(to: CGPoint(x: point.x, y: point.y))
            }
        })
        
        context?.setLineWidth(0.0)
        context?.setFillColor(config.lineColor.cgColor )
        
        if self.config.dotEnable {
            ps.forEach({point in
                let r = CGRect(x: point.x - CGFloat(self.config.dotDiameter / 2.0), y: point.y - CGFloat(self.config.dotDiameter / 2.0), width: CGFloat(self.config.dotDiameter), height: CGFloat(self.config.dotDiameter))
                context?.strokeEllipse(in: r)
                context?.fillEllipse(in: r)
            })
        }
        
        zip(lineGraph.units, ps).forEach { (u, p) in
            
            guard let str = self.graph?.graphTextDisplay()(u, total) else {
                return
            }
            
            let attrStr = NSAttributedString.graphAttributedString(str, color: self.config.textColor, font: self.config.textFont)
            
            let size = attrStr.size()
            
            attrStr.draw(
                in: CGRect(
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
    
    fileprivate func graphFrame() -> CGRect {
        return CGRect(
            x: self.config.contentInsets.left,
            y: self.config.contentInsets.top,
            width: self.frame.size.width - self.config.contentInsets.horizontalMarginsTotal(),
            height: self.frame.size.height - self.config.contentInsets.verticalMarginsTotal()
        )
    }
    
    fileprivate func points(_ graph: LineGraph<T, U>, rect: CGRect) -> [CGPoint] {
        
        let sectionWidth = rect.width / CGFloat(graph.units.count)
        
        return graph.units.enumerated().map {
            CGPoint(
                x: CGFloat($0) * sectionWidth + (sectionWidth / 2.0) + rect.origin.x,
                y: rect.size.height - rect.size.height * CGFloat(($1.value - graph.range.min).floatValue() / (graph.range.max - graph.range.min).floatValue()) + rect.origin.y
            )
        }
    }
    
}
