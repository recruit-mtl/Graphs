//
//  BarGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/03.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

enum GraphColorType {
    case
    Mat(UIColor),
    Gradation(UIColor, UIColor)
}

extension UIColor {
    
    func matColor() -> GraphColorType {
        return .Mat(self)
    }
}

struct BarGraphViewConfig {
    
    var barColor: GraphColorType
    var textColor: UIColor
    var textVisible: Bool
    var zeroLineVisible: Bool
    var barWidthScale: CGFloat
    var sectionWidth: CGFloat?
    
    init(
        barColor: UIColor? = nil,
        textColor: UIColor? = nil,
        barWidthScale: CGFloat? = nil,
        sectionWidth: CGFloat? = nil,
        zeroLineVisible: Bool? = nil,
        textVisible: Bool? = nil
    ) {
        self.barColor = (barColor ?? DefaultColorType.Bar.color()).matColor()
        self.textColor = textColor ?? DefaultColorType.BarText.color()
        self.barWidthScale = barWidthScale ?? 0.8
        self.sectionWidth = sectionWidth
        self.zeroLineVisible = zeroLineVisible ?? true
        self.textVisible = textVisible ?? true
    }
    
    mutating func setBarColor(color: UIColor?) {
        self.barColor = (color ?? DefaultColorType.Bar.color()).matColor()
    }
}


public class BarGraphView<T: Hashable, U: NumericType>: UIView {
    
    public typealias BarGraphTextDisplayHandler = (GraphUnit<T, U>) -> String?
    
    public var textDisplayHandler: BarGraphTextDisplayHandler
    
    internal var graph: BarGraph<T, U>?
    
    private var config = BarGraphViewConfig()
    
    public init(frame: CGRect, graph: BarGraph<T, U>?, textDisplayHandler: BarGraphTextDisplayHandler) {
        
        self.graph = graph
        
        self.textDisplayHandler = textDisplayHandler
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
    }
    
    public var barColor: UIColor? = nil {
        didSet {
            self.config.setBarColor(barColor)
            self.setNeedsDisplay()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        guard let graph = self.graph else { return }
        
        graph.units.enumerate().forEach({ (index, u) in
            let min = graph.range.min
            let max = graph.range.max
            let barWidthScale = self.config.barWidthScale
            let barColor = self.config.barColor
            
            switch barColor {
            case let .Mat(color):
                color.setFill()
            case .Gradation(_, _):
                break
            }
            
            let sectionWidth = self.config.sectionWidth ?? (self.frame.size.width / CGFloat(graph.units.count))
            let width = sectionWidth * barWidthScale
            
            let zero = self.frame.size.height / CGFloat((max - min).floatValue()) * CGFloat(min.floatValue() - 0.0)
            
            let height = { () -> CGFloat in
                switch u.value {
                case let n where n > U(0):
                    return self.frame.size.height * CGFloat(
                        u.value.floatValue() / (max - min).floatValue()
                    )
                case let n where n < U(0):
                    return self.frame.size.height * CGFloat(
                        -(u.value).floatValue() / (max - min).floatValue()
                    )
                case _:
                    return 0.0
                }
            }()

            let path = UIBezierPath(
                rect: CGRect(
                    x: sectionWidth * CGFloat(index) + (sectionWidth - width) / 2.0,
                    y: u.value >= U(0) ? self.frame.size.height - height + zero : self.frame.size.height + zero,
                    width: width,
                    height: height
                )
            )
            path.fill()
            
            if let str = self.textDisplayHandler(u) {
                
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
                            x: sectionWidth * CGFloat(index),
                            y: u.value >= U(0)
                                ? self.frame.size.height - height + zero - size.height
                                : self.frame.size.height + zero + height
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