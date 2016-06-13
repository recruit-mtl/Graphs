//
//  GraphTableViewCell.swift
//  GraphsExample
//
//  Created by HiraiKokoro on 2016/06/10.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit
import Graphs

class GraphTableViewCell: UITableViewCell {
    
    @IBOutlet private var graphAreaView: UIView!
    
    private var graphView: GraphView<String, Int>?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setGraph(graph: Graph<String, Int>) {
        
        guard let graphView = self.graphView else {
            self.graphView = graph.view(self.graphAreaView.bounds)
            self.graphAreaView.addSubview(self.graphView!)
            self.graphView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            self.setGraph(graph)
            return
        }

        graphView.graph = graph
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
