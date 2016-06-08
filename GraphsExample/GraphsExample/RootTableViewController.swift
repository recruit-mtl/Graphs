//
//  RootTableViewController.swift
//  GraphsExample
//
//  Created by HiraiKokoro on 2016/06/08.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

enum GraphType {
    case
    BarGraph,
    LineGraph,
    PieGraph
    
    static func count() -> Int {
        return self.all().count
    }
    
    static func all() -> [GraphType] {
        return [
            .BarGraph,
            .LineGraph,
            .PieGraph
        ]
    }
    
    func title() -> String {
        switch self {
        case .BarGraph:     return "Bar graph"
        case .LineGraph:    return "Line graph"
        case .PieGraph:     return "Pie graph"
        }
    }
}

class RootTableViewController: UITableViewController {
    
    private let graphSegueIdentifier = "graph"

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some(graphSegueIdentifier):
            let index = sender as! Int
            (segue.destinationViewController as! GraphViewController).graphType = GraphType.all()[index]
            break
        case _:
            break
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GraphType.count()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.textLabel?.text = GraphType.all()[indexPath.row].title()

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(graphSegueIdentifier, sender: indexPath.row)
    }
    

}
