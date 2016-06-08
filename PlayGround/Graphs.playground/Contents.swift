//: Playground - noun: a place where people can play

import UIKit
import Graphs

var str = "Hello, playground"

let array: [Double] = [1.0, 20.0, -3.0, 4.0, 25.0, 1.0, 20.2, 3.0, 4.0, 25.0]

let array2: [Double] = [5.0, 20.0, -20.0, 4.0, 25.0, 1.0, 20.2, 3.0, 4.0, 25.0]

let range = GraphRange<Double>(min: -10.0, max: 30.0)

let frame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 240.0)

let barGraphView = array.barGraph(range).view(frame)

let preview = barGraphView

barGraphView.graph = array2.barGraph(range)

let lineGraphView = array.lineGraph(range).view(frame)

let linePreview = lineGraphView

let pieGraphView = array.pieGraph().view(frame)

let piePreview = pieGraphView
