
import UIKit
import Graphs

let str = "Hello Graphs!!"

let viewFrame = CGRect(x: 0.0, y: 0.0, width: 480.0, height: 480.0)

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


/// Dictionary -> Graph
let dict = [
    "A": 20.0,
    "B": 3.14,
    "C": 100.3,
    "D": 30.0,
    "E": 80.0
]
let pieGraph7 = dict.pieGraph() { (unit, totalValue) -> String? in
    return unit.key! + ":" + String(unit.value)
}
let pieGraphView7 = pieGraph7.view(viewFrame)

/// GraphData Protocol -> Graph

struct Data<T: Hashable, U: NumericType>: GraphData {
    typealias GraphDataKey = T
    typealias GraphDataValue = U
    
    private let _key: T
    private let _value: U
    
    init(key: T, value: U) {
        self._key = key
        self._value = value
    }
    
    var key: T { get{ return self._key } }
    var value: U { get{ return self._value } }
}

let data = [
    Data(key: "John", value: 18.9),
    Data(key: "Ken", value: 32.9),
    Data(key: "Taro", value: 15.3),
    Data(key: "Micheal", value: 22.9),
    Data(key: "Jun", value: 12.9),
    Data(key: "Hanako", value: 32.2),
    Data(key: "Kent", value: 3.8)
]

let pieGraph8 = data.pieGraph() { (unit, totalValue) -> String? in
    return unit.key! + "\n" + String(format: "%.0f%%", unit.value / totalValue * 100.0)
}

let pieGraphView8 = pieGraph8.view(viewFrame)

