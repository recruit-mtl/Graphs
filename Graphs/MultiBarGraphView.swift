//
//  MultiBarGraphView.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/06/09.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

class MultiBarGraphView<T: Hashable, U: NumericType>: UIView {
    
    private var scrollView: UIScrollView!
    
    private var graph: MultiBarGraph<T, U>?
    private var config: MultiBarGraphViewConfig<U>
    
    init(frame: CGRect, graph: MultiBarGraph<T, U>?, viewConfig: MultiBarGraphViewConfig<U>? = nil) {
        
        self.config = viewConfig ?? MultiBarGraphViewConfig<U>()
        super.init(frame: frame)
        self.graph = graph
        self.scrollView = UIScrollView(
            frame: CGRect(x: 20.0, y: 0.0, width: self.bounds.width - 20.0, height: self.bounds.height - 20.0)
        )
        self.addSubview(self.scrollView)
    }
}

struct MultiBarGraphViewConfig<T: NumericType> {
    
    let barColors: [UIColor]
    let barWidthScale: CGFloat
    var sectionWidth: CGFloat?
    
    init(
        barColors: [UIColor]? = nil,
        barWidthScale: CGFloat? = nil,
        sectionWidth: CGFloat? = nil
        ) {
        self.barColors = barColors ?? [DefaultColorType.Bar.color()]
        self.barWidthScale = barWidthScale ?? 0.8
        self.sectionWidth = sectionWidth
    }
}
