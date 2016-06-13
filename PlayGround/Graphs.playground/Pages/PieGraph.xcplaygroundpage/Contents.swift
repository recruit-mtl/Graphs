
import UIKit
import Graphs

let str = "Hello Graphs!!"

let viewFrame = CGRect(x: 0.0, y: 0.0, width: 320.0, height: 320.0)

/* ========= Pie graph ========= */

let pieGraph = Graph<String, Int>(type: .Pie, array: [10, 20, 4, 8, 25, 18, 21, 24, 8, 15], min: 0, max: 30)
let pieGraphView = GraphView(frame: viewFrame, graph: pieGraph)

/// Array -> Graph
let pieGraphView1 = (1 ... 10).pieGraph().view(viewFrame)

/// Set graphs text
let pieGraph3 = (1 ... 4).pieGraph(){(u, _) -> String? in "\(u.value)pt"}
let pieGraphView3 = pieGraph3.view(viewFrame)

/// Set views apperances
let v4 = pieGraph3.view(viewFrame).pieGraphConfiguration {
    PieGraphViewConfig(
        pieColors: [
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ]
    )
}
let pieGraphView4 = v4

let v5 = pieGraph3.view(viewFrame).pieGraphConfiguration {
    PieGraphViewConfig(
        pieColors: [
            UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0),
            UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0),
            UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        ],
        textColor: UIColor.whiteColor(),
        textFont: UIFont.boldSystemFontOfSize(12.0),
        isDounut: true
    )
}
let lineGraphView5 = v5

/// Minus values
let v6 = [-5.0, -4.0, -3.0, -2.0, -1.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0].map{ $0 * 10.0 }.pieGraph().view(viewFrame)
let pieGraphView6 = v6

/// Dictionary -> Graph
let dict = [
    "A": 20.0,
    "B": 3.14,
    "C": 100.3,
    "D": 30.0
]
let pieGraph7 = dict.pieGraph() { (unit, totalValue) -> String? in
    return unit.key! + ":" + String(unit.value)
}
let pieGraphView7 = pieGraph7.view(viewFrame)
