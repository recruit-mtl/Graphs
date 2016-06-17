//
//  MainViewController.swift
//  GraphsExample
//
//  Created by HiraiKokoro on 2016/06/15.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit
import Graphs

enum GraphExampleType: Int {
    case
    BarGraph1,
    BarGraph2,
    BarGraph3,
    LineGraph1,
    LineGraph2,
    LineGraph3,
    PieGraph1,
    PieGraph2,
    PieGraph3
    
    static func count() -> Int {
        return 9
    }
    
}

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        self.collectionView.reloadData()
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        
        self.collectionView.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        self.collectionView.reloadData()
    }
    

    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GraphExampleType.count()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! GraphCollectionViewCell
        
        cell.graphView.subviews.forEach({ $0.removeFromSuperview() })
        
        switch GraphExampleType(rawValue: indexPath.row)! {
        case .BarGraph1:
            
            let view = (1 ... 10).barGraph(GraphRange(min: 0, max: 11)).view(cell.graphView.bounds)
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "let view = (1 ... 10).barGraph(GraphRange(min: 0, max: 11)).view(cell.graphView.bounds)"
        
        case .BarGraph2:
            
            let view = [8, 12, 20, -10, 6, 20, -11, 9, 12, 16, -10, 6, 20, -12].barGraph().view(cell.graphView.bounds).barGraphConfiguration({ BarGraphViewConfig(barColor: UIColor(hex: "#ff6699"), contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "[8, 12, 20, -10, 6, 20, -11, 9, 12, 16, -10, 6, 20, -12].barGraph().view(cell.graphView.bounds).barGraphConfiguration({ BarGraphViewConfig(barColor: UIColor(hex: \"#ff6699\"), contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) })"
            
        case .BarGraph3:
            
            let view = [8.0, 12.0, 20.0, 10.0, 6.0, 20.0, 11.0, 9.0, 12.0, 16.0, 10.0, 6.0, 20.0].barGraph(GraphRange(min: 0, max: 25)).view(cell.graphView.bounds).barGraphConfiguration({ BarGraphViewConfig(barColor: UIColor(hex: "#ccff66"), barWidthScale: 0.4) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "let view = [8.0, 12.0, 20.0, 10.0, 6.0, 20.0, 11.0, 9.0, 12.0, 16.0, 10.0, 6.0, 20.0].barGraph(GraphRange(min: 0, max: 25)).view(cell.graphView.bounds).barGraphConfiguration({ BarGraphViewConfig(barColor: UIColor(hex: \"#ccff66\"), barWidthScale: 0.4) })"
            
        case .LineGraph1:
            
            let view = (1 ... 10).lineGraph(GraphRange(min: 0, max: 11)).view(cell.graphView.bounds)
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "let view = (1 ... 10).lineGraph(GraphRange(min: 0, max: 11)).view(cell.graphView.bounds)"
            
        case .LineGraph2:
            
            let view = [8, 12, 20, -10, 6, 20, -11, 9, 12, 16, -10, 6, 20, -12].lineGraph().view(cell.graphView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: UIColor(hex: "#ff6699"), contentInsets: UIEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "[8, 12, 20, -10, 6, 20, -11, 9, 12, 16, -10, 6, 20, -12].lineGraph().view(cell.graphView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: UIColor(hex: \"#ff6699\"), contentInsets: UIEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)) })"
            
        case .LineGraph3:
            
            let view = [8.0, 12.0, 20.0, 10.0, 6.0, 20.0, 11.0, 9.0, 12.0, 16.0, 10.0, 6.0, 20.0].lineGraph(GraphRange(min: 0, max: 25)).view(cell.graphView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: UIColor(hex: "#ccff33"), lineWidth: 2.0, dotDiameter: 20.0) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "[8.0, 12.0, 20.0, 10.0, 6.0, 20.0, 11.0, 9.0, 12.0, 16.0, 10.0, 6.0, 20.0].lineGraph(GraphRange(min: 0, max: 25)).view(cell.graphView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: UIColor(hex: \"#ccff66\"), lineWidth: 1.0, dotDiameter: 10.0) })"
            
        case .PieGraph1:
            
            let view = (5 ... 10).pieGraph().view(cell.graphView.bounds)
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "(5 ... 10).pieGraph().view(cell.graphView.bounds)"
            
        case .PieGraph2:
            
            let view = [8, 12, 20, 6, 20, 11, 9].pieGraph(){ (u, t) -> String? in String(format: "%.0f%%", (Float(u.value) / Float(t)))}.view(cell.graphView.bounds).pieGraphConfiguration({ PieGraphViewConfig(textFont: UIFont(name: "DINCondensed-Bold", size: 14.0), isDounut: true, contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "[8, 12, 20, 6, 20, 11, 9].pieGraph(){ (u, t) -> String? in String(format: \"%.0f%%\", (Float(u.value) / Float(t)))}.view(cell.graphView.bounds).pieGraphConfiguration({ PieGraphViewConfig(textFont: UIFont(name: \"DINCondensed-Bold\", size: 14.0), isDounut: true, contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) })"
            
        case .PieGraph3:
            
            let view = [8.5, 20.0].pieGraph(){ (u, t) -> String? in String(format: "%.0f%%", (Float(u.value) / Float(t)))}.view(cell.graphView.bounds).pieGraphConfiguration({ PieGraphViewConfig(textFont: UIFont(name: "DINCondensed-Bold", size: 14.0), isDounut: true, contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphView.addSubview(view)
            
            cell.label.text = "[8.5, 20.0].pieGraph(){ (u, t) -> String? in String(format: \"%.0f%%\", (Float(u.value) / Float(t)))}.view(cell.graphView.bounds).pieGraphConfiguration({ PieGraphViewConfig(textFont: UIFont(name: \"DINCondensed-Bold\", size: 14.0), isDounut: true, contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)) })"
            
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath)
            return view
        case _:
            return UICollectionReusableView()
        }
    }
    
    private let cellMargin = CGFloat(8.0)
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        

        let regularCollection = UITraitCollection(horizontalSizeClass: .Regular)
        
        let horizontalCellCount = self.traitCollection.containsTraitsInCollection(regularCollection) ? 2 : 1
        let width = (collectionView.frame.size.width - cellMargin * CGFloat(horizontalCellCount + 1)) / CGFloat(horizontalCellCount)
        
        return CGSize(
            width: width,
            height: width * CGFloat(1.1)
        )
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 120.0)
    }

}
