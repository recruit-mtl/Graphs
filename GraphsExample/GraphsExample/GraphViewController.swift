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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! GraphTableViewCell
        
        let array = [20, 1, 2, 5, -10, 3, 20, 5]
        
        let range = GraphRange(min: -15, max: 25)
        
        let graph = array.barGraph(range)
        
        cell.setGraph(graph)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160.0
    }

}
