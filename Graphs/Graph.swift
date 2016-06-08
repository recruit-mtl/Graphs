//
//  Graph.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/05/30.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public class Graph<T: Hashable, U: NumericType> {
    
    let type: GraphType<T, U>
    
    init(barGraph: BarGraph<T, U>) {
        self.type = GraphType<T, U>.Bar(barGraph)
    }
    
    init(lineGraph: LineGraph<T, U>) {
        self.type = GraphType<T, U>.Line(lineGraph)
    }
    
    init(pieGraph: PieGraph<T, U>) {
        self.type = GraphType<T, U>.Pie(pieGraph)
    }
}

public extension Graph {
    
    public func view(frame: CGRect) -> GraphView<T, U> {
        return GraphView(frame: frame, graph: self)
    }
}



public enum GraphType<T: Hashable, U: NumericType> {
    case
    Bar(BarGraph<T, U>),
    Line(LineGraph<T, U>),
    Pie(PieGraph<T, U>)
    
    internal static func barGraph(units: [GraphUnit<T, U>], range: GraphRange<U>) -> GraphType<T, U> {
        return GraphType<T, U>.Bar(BarGraph(units: units, range: range))
    }
    
    internal static func lineGraph(units: [GraphUnit<T, U>], range: GraphRange<U>) -> GraphType<T, U> {
        return GraphType<T, U>.Line(LineGraph(units: units, range: range))
    }
    
    internal static func pieGraph(units: [GraphUnit<T, U>]) -> GraphType<T, U> {
        return GraphType<T, U>.Pie(PieGraph(units: units))
    }
}

public protocol GraphBase {
    
    associatedtype UnitsType
    associatedtype RangeType
    
    var units: UnitsType { get }
//    var range: RangeType { get }
    
}

public struct BarGraph<T: Hashable, U: NumericType>: GraphBase {
    
    public typealias GraphView = BarGraphView<T, U>
    public typealias UnitsType = [GraphUnit<T, U>]
    public typealias RangeType = GraphRange<U>
    
    public var units: [GraphUnit<T, U>]
    public var range: GraphRange<U>
    public var textDisplayHandler: BarGraphView<T, U>.BarGraphTextDisplayHandler?
    
    public init(
        units: [GraphUnit<T, U>],
        range: GraphRange<U>,
        textDisplayHandler: BarGraphView<T, U>.BarGraphTextDisplayHandler? = nil
    ) {
        self.units = units
        self.range = range
        self.textDisplayHandler = textDisplayHandler
    }

    public func view(frame: CGRect) -> GraphView? {
        return BarGraphView<T, U>(
            frame: frame,
            graph: self,
            textDisplayHandler: {() -> BarGraphView<T, U>.BarGraphTextDisplayHandler in
                if let h = textDisplayHandler {
                    return h
                }
                return { u -> String in String(u.value) }
            }()
        )
    }
}

public struct MultiBarGraph<T: Hashable, U: NumericType>: GraphBase {
    
    public typealias UnitsType = [[GraphUnit<T, U>]]
    public typealias RangeType = GraphRange<U>
    
    public var units: [[GraphUnit<T, U>]]
    public var range: GraphRange<U>
}

public struct LineGraph<T: Hashable, U: NumericType>: GraphBase {
    
    public typealias GraphView = LineGraphView<T, U>
    public typealias UnitsType = [GraphUnit<T, U>]
    public typealias RangeType = GraphRange<U>
    
    
    public var units: [GraphUnit<T, U>]
    public var range: GraphRange<U>
    
    public func view(frame: CGRect) -> GraphView? {
        return LineGraphView(frame: frame, graph: self) { u -> String? in
            return String(u.value)
        }
    }
}

public struct PieGraph<T: Hashable, U: NumericType>: GraphBase {
    
    public typealias GraphView = PieGraphView<T, U>
    public typealias UnitsType = [GraphUnit<T, U>]
    public typealias RangeType = GraphRange<U>
    
    public var units: [GraphUnit<T, U>]
    
    public func view(frame: CGRect) -> GraphView? {
        return PieGraphView(frame: frame, graph: self) { (u, totalValue) -> String? in
            let f = u.value.floatValue() / totalValue.floatValue()
            return String(u.value) + " : " + String(format: "%.1f", f)
        }
    }
}


public struct GraphUnit<T: Hashable, U: NumericType> {
    public let key: T?
    public let value: U
    
    public init(key: T?, value: U) {
        self.key = key
        self.value = value
    }
}

public struct GraphRange<T: NumericType> {
    let min: T
    let max: T
    
    public init(min: T, max: T) {
        self.min = min
        self.max = max
    }
}



public struct BarGraphConfig<T: NumericType> {
    public let minimumValue: T
    public let maximumValue: T
    
    public init(minimumValue: T, maximumValue: T) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
}

public struct BarGraphApperance {
    public let barColor: UIColor
    public let barWidthScale: CGFloat
    public let valueTextAttributes: GraphTextAttributes?
    
    init(
        barColor: UIColor?,
        barWidthScale: CGFloat?,
        valueTextAttributes: GraphTextAttributes?
    ) {
        self.barColor = barColor ?? DefaultColorType.Bar.color()
        self.barWidthScale = barWidthScale ?? 0.8
        self.valueTextAttributes = valueTextAttributes
    }
}

public struct GraphTextAttributes {
    public let font: UIFont
    public let textColor: UIColor
    public let textAlign: NSTextAlignment
    
    init(
        font: UIFont?,
        textColor: UIColor?,
        textAlign: NSTextAlignment?
    ) {
        self.font = font ?? UIFont.systemFontOfSize(10.0)
        self.textColor = textColor ?? UIColor.grayColor()
        self.textAlign = textAlign ?? .Center
    }
}

public struct MultiBarGraphConfig<T: NumericType> {
    public let minimumValue: T
    public let maximumValue: T
    
    public init(minimumValue: T, maximumValue: T) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
}

public struct LineGraphConfig<T: NumericType> {
    public let minimumValue: T
    public let maximumValue: T
    
    public init(minimumValue: T, maximumValue: T) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
    }
}





public protocol NumericType: Equatable, Comparable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    init()
    init(_ v: Int)
}

extension NumericType {
    
    func floatValue() -> Float {
        if let n = self as? Int {
            return Float(n)
        }
        if let n = self as? Float {
            return Float(n)
        }
        if let n = self as? Double {
            return Float(n)
        }
        return 0.0
    }
    
    static func zero<T: NumericType>() -> T {
        return T(0)
    }
}

extension Double : NumericType { }
extension Float  : NumericType { }
extension Int    : NumericType { }
extension Int8   : NumericType { }
extension Int16  : NumericType { }
extension Int32  : NumericType { }
extension Int64  : NumericType { }
extension UInt   : NumericType { }
extension UInt8  : NumericType { }
extension UInt16 : NumericType { }
extension UInt32 : NumericType { }
extension UInt64 : NumericType { }
