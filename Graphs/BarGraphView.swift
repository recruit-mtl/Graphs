//
//  BarGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/03.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public enum GraphColorType {
    case
    Mat(UIColor),
    Gradation(UIColor, UIColor)
}

extension UIColor {
    
    func matColor() -> GraphColorType {
        return .Mat(self)
    }
}

public struct BarGraphViewConfig {
    
    public var barColor: GraphColorType
    public var textColor: UIColor
    public var textFont: UIFont
    public var textVisible: Bool
    public var zeroLineVisible: Bool
    public var barWidthScale: CGFloat
    public var contentInsets: UIEdgeInsets
    
    public init(
        barColor: UIColor? = nil,
        textColor: UIColor? = nil,
        textFont: UIFont? = nil,
        barWidthScale: CGFloat? = nil,
        zeroLineVisible: Bool? = nil,
        textVisible: Bool? = nil,
        contentInsets: UIEdgeInsets? = nil
    ) {
        self.barColor = (barColor ?? DefaultColorType.Bar.color()).matColor()
        self.textColor = textColor ?? DefaultColorType.BarText.color()
        self.textFont = textFont ?? UIFont.systemFontOfSize(10.0)
        self.barWidthScale = barWidthScale ?? 0.8
        self.zeroLineVisible = zeroLineVisible ?? true
        self.textVisible = textVisible ?? true
        self.contentInsets = contentInsets ?? UIEdgeInsetsZero
    }
}


internal class BarGraphView<T: Hashable, U: NumericType>: UIView {

    
    internal var graph: BarGraph<T, U>?
    
    private var config = BarGraphViewConfig()
    
    init(frame: CGRect, graph: BarGraph<T, U>?) {
        
        self.graph = graph
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.setNeedsDisplay()
    }
    
    func setBarGraphViewConfig(config: BarGraphViewConfig?) {
        
        self.config = config ?? BarGraphViewConfig()
        self.setNeedsDisplay()
    }
    
    private func graphFrame() -> CGRect {
        return CGRect(
            x: self.config.contentInsets.left,
            y: self.config.contentInsets.top,
            width: self.frame.size.width - self.config.contentInsets.horizontalMarginsTotal(),
            height: self.frame.size.height - self.config.contentInsets.verticalMarginsTotal()
        )
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let graph = self.graph else { return }
        
        let total = graph.units.map{ $0.value }.reduce(U(0)){ $0 + $1 }
        let rect = self.graphFrame()
        let min = graph.range.min
        let max = graph.range.max
        
        let sectionWidth = rect.size.width / CGFloat(graph.units.count)
        let width = sectionWidth * self.config.barWidthScale
        
        let zero = rect.size.height / CGFloat((max - min).floatValue()) * CGFloat(min.floatValue())
        
        graph.units.enumerate().forEach({ (index, u) in
            
            switch self.config.barColor {
            case let .Mat(color):   color.setFill()
            case .Gradation(_, _):  break
            }
            
            let height = { () -> CGFloat in
                switch u.value {
                case let n where n > U(0):
                    return rect.size.height * CGFloat(
                        u.value.floatValue() / (max - min).floatValue()
                    )
                case let n where n < U(0):
                    return rect.size.height * CGFloat(
                        -(u.value).floatValue() / (max - min).floatValue()
                    )
                case _:
                    return 0.0
                }
            }()

            let path = UIBezierPath(
                rect: CGRect(
                    x: sectionWidth * CGFloat(index) + (sectionWidth - width) / 2.0 + rect.origin.x,
                    y: (u.value >= U(0) ? rect.size.height - height : rect.size.height) + zero + rect.origin.y,
                    width: width,
                    height: height
                )
            )
            path.fill()
            
            if let str = self.graph?.graphTextDisplay()(unit: u, totalValue: total) {
                
                let attrStr = NSAttributedString.graphAttributedString(str, color: self.config.textColor, font: self.config.textFont)
                
                let size = attrStr.size()
                
                attrStr.drawInRect(
                    CGRect(
                        origin: CGPoint(
                            x: sectionWidth * CGFloat(index) + rect.origin.x,
                            y: u.value >= U(0)
                                ? rect.size.height - height + zero - size.height - 3.0 + rect.origin.y
                                : rect.size.height + zero + height + 3.0 + rect.origin.y
                        ),
                        size: CGSize(
                            width: sectionWidth,
                            height: size.height
                        )
                    )
                )
            }
        })
    }
}