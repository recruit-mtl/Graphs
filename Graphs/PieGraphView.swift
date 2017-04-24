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
        self.textColor = textColor ?? DefaultColorType.pieText.color()
        self.textFont = textFont ?? UIFont.systemFont(ofSize: 10.0)
        self.isDounut = isDounut
        self.contentInsets = contentInsets ?? UIEdgeInsets.zero
    }
    
}

internal class PieGraphView<T: Hashable, U: NumericType>: UIView {
    
    fileprivate var graph: PieGraph<T, U>? {
        didSet {
            self.config.pieColors = DefaultColorType.pieColors(graph?.units.count ?? 0)
            self.setNeedsDisplay()
        }
    }
    fileprivate var config: PieGraphViewConfig
    
    init(frame: CGRect, graph: PieGraph<T, U>?) {
        
        self.config = PieGraphViewConfig(pieColors: DefaultColorType.pieColors(graph?.units.count ?? 0))
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.graph = graph
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPieGraphViewConfig(_ config: PieGraphViewConfig?) {
        self.config = config ?? PieGraphViewConfig()
        self.setNeedsDisplay()
    }

    // This generic function has to be put outside of "draw(_ rect: CGRect)", to avoid Swift compiler segmentation fault 11
    func convert<S: NumericType>(_ s: S, arr: [S], f: (S) -> S) -> [S] {
        switch arr.match {
        case let .some(h, t):   return [(f(h) + s) as S] + convert(h + s, arr:t, f: f)
        case .none:             return []
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let graph = self.graph else { return }

        let colors = self.config.pieColors ?? DefaultColorType.pieColors(graph.units.count)

        let values = graph.units.map({ max($0.value, U(0)) })
        let total = values.reduce(U(0), { $0 + $1 })
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

        percentages.enumerated().forEach { (index, f) in
            let endAngle = startAngle + M_PI * 2.0 * f
            context?.move(to: CGPoint(x: x, y: y));
            context?.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: false)

            if self.config.isDounut {
                context?.addArc(center: CGPoint(x: x, y: y), radius: radius/2, startAngle: CGFloat(endAngle), endAngle: CGFloat(startAngle), clockwise: true)
            }
            
            if let comps = colors[index].cgColor.components {
                context?.setFillColor(comps)
            }
            context?.closePath();
            context?.fillPath();
            startAngle = endAngle
        }
        
        zip(graph.units, centers).forEach { (u, center) in
            
            guard let str = self.graph?.graphTextDisplay()(u, total) else {
                return
            }
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let attrStr = NSAttributedString(string: str, attributes: [
                NSForegroundColorAttributeName:self.config.textColor,
                NSFontAttributeName: UIFont.systemFont(ofSize: 10.0),
                NSParagraphStyleAttributeName: paragraph
            ])
            
            let size = attrStr.size()
            
            attrStr.draw(
                in: CGRect(
                    origin: CGPoint(
                        x: center.x - size.width / 2.0,
                        y: center.y - size.height / 2.0
                    ),
                    size: size
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

}
