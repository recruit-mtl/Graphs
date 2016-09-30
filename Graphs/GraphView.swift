//
//  GraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/01.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public class GraphView<T: Hashable, U: NumericType>: UIView {
    
    public var graph: Graph<T, U>? {
        didSet {
            self.reloadData()
        }
    }
    
    var barGraphConfig: BarGraphViewConfig?
    var lineGraphConfig: LineGraphViewConfig?
    var pieGraphConfig: PieGraphViewConfig?
    
    public init(frame: CGRect, graph: Graph<T, U>? = nil) {
        self.graph = graph
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clear
        self.reloadData()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        self.reloadData()
    }
    
    func reloadData() {
        
        self.subviews.forEach { $0.removeFromSuperview() }
        
        guard let graph = self.graph else { return }
        
        switch graph.kind {
        case .Bar(let g):
            
            if let view = g.view(frame: self.bounds) {
                if let c = barGraphConfig {
                    view.setBarGraphViewConfig(config: c)
                }
                self.addSubview(view)
            }
            
        case .Line(let g):
            
            if let view = g.view(frame: self.bounds) {
                if let c = lineGraphConfig {
                    view.setLineGraphViewConfig(config: c)
                }
                self.addSubview(view)
            }
            
        case .Pie(let g):
            
            if let view = g.view(frame: self.bounds) {
                if let c = pieGraphConfig {
                    view.setPieGraphViewConfig(config: c)
                }
                self.addSubview(view)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.subviews.forEach{
            $0.frame = self.bounds
        }
    }
}

extension GraphView {
    
    public func barGraphConfiguration(configuration: () -> BarGraphViewConfig) -> Self {
        self.barGraphConfig = configuration()
        self.subviews.forEach { (v) in
            if let barGraphView = v as? BarGraphView<T, U> {
                barGraphView.setBarGraphViewConfig(config: barGraphConfig)
            }
        }
        return self
    }
    
    public func lineGraphConfiguration(configuration: () -> LineGraphViewConfig) -> Self {
        self.lineGraphConfig = configuration()
        self.subviews.forEach { (v) in
            if let lineGraphView = v as? LineGraphView<T, U> {
                lineGraphView.setLineGraphViewConfig(config: lineGraphConfig)
            }
        }
        return self
    }
    
    public func pieGraphConfiguration(configuration: () -> PieGraphViewConfig) -> Self {
        self.pieGraphConfig = configuration()
        self.subviews.forEach { (v) in
            if let pieGraphView = v as? PieGraphView<T, U> {
                pieGraphView.setPieGraphViewConfig(config: pieGraphConfig)
            }
        }
        return self
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

