//
//  GraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/01.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public class GraphView<T: Hashable, U: NumericType>: UIView {
    
    private var scrollView: UIScrollView!
    
    public var graph: Graph<T, U> {
        didSet {
            self.reloadData()
        }
    }
    
    public init(frame: CGRect, graph: Graph<T, U>) {
        self.graph = graph
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        
        self.scrollView = UIScrollView(frame: self.bounds)
        self.addSubview(self.scrollView)
        
        self.reloadData()
    }
    
    public func reloadData() {
        
        self.scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        switch self.graph.type {
        case .Bar(let g):
            
            if let view = g.view(self.scrollView.frame) {
                self.scrollView.addSubview(view)
                self.scrollView.contentSize = self.scrollView.frame.size
            }
            
        case .Line(let g):
            
            if let view = g.view(self.scrollView.frame) {
                self.scrollView.addSubview(view)
            }
            
        case .Pie(let g):
            
            if let view = g.view(self.scrollView.frame) {
                self.scrollView.addSubview(view)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.subviews.forEach{
            $0.frame = self.scrollView.insetBounds()
        }
    }
    
    public override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.reloadData()
    }
}

extension UIScrollView {
    
    func insetBounds() -> CGRect {
        
        return CGRect(
            x: self.bounds.origin.x + self.contentInset.left,
            y: self.bounds.origin.y + self.contentInset.top,
            width: self.bounds.size.width - self.contentInset.left - self.contentInset.right,
            height: self.bounds.size.height - self.contentInset.top - self.contentInset.bottom
        )
    }
}


public class MultiBarGraphView<T: Hashable, U: NumericType>: UIView {
    
    private var scrollView: UIScrollView!
    
    private var graph: MultiBarGraph<T, U>?
    private var config: MultiBarGraphViewConfig<U>
    
    public init(frame: CGRect, graph: MultiBarGraph<T, U>?, viewConfig: MultiBarGraphViewConfig<U>? = nil) {
        
        self.config = viewConfig ?? MultiBarGraphViewConfig<U>()
        super.init(frame: frame)
        self.graph = graph
        self.scrollView = UIScrollView(
            frame: CGRect(x: 20.0, y: 0.0, width: self.bounds.width - 20.0, height: self.bounds.height - 20.0)
        )
        self.addSubview(self.scrollView)
    }
}




public struct MultiBarGraphViewConfig<T: NumericType> {
    
    public let barColors: [UIColor]
    public let barWidthScale: CGFloat
    public var sectionWidth: CGFloat?
    
    public init(
        barColors: [UIColor]? = nil,
        barWidthScale: CGFloat? = nil,
        sectionWidth: CGFloat? = nil
        ) {
        self.barColors = barColors ?? [DefaultColorType.Bar.color()]
        self.barWidthScale = barWidthScale ?? 0.8
        self.sectionWidth = sectionWidth
    }
}

