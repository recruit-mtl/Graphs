//
//  GraphViewController.swift
//  
//
//  Created by HiraiKokoro on 2016/06/08.
//
//

import UIKit
import Graphs

class GraphViewController: UITableViewController {
    
    var graphType: GraphType!

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let array = [0, 1, 2, 5, -10, 3, 20, 5]
        
        let range = GraphRange(min: -15, max: 25)
        
        let graph = array.barGraph(range)
        
        
        if indexPath.row == 0 {
            graph.writeUnits({ (us) -> [GraphUnit<String, Int>] in
                let new = us.map({ _ -> GraphUnit<String, Int> in return GraphUnit<String, Int>(key: nil, value: 10) })
                return new
            })
        }
        
        let view = graph.view(cell.contentView.bounds)
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        cell.contentView.addSubview(view)
        
        return cell
    }

}
