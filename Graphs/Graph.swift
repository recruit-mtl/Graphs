//
//  Graph.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/05/30.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

public enum GraphType {
    case
    Bar,
    Line,
    Pie
}

public class Graph<T: Hashable, U: NumericType> {
    
    public typealias GraphTextDisplayHandler = (unit: GraphUnit<T, U>, totalValue: U) -> String?
    
    let kind: GraphKind<T, U>
    
    
    init(barGraph: BarGraph<T, U>) {
        self.kind = GraphKind<T, U>.Bar(barGraph)
    }
    
    init(lineGraph: LineGraph<T, U>) {
        self.kind = GraphKind<T, U>.Line(lineGraph)
    }
    
    init(pieGraph: PieGraph<T, U>) {
        self.kind = GraphKind<T, U>.Pie(pieGraph)
    }
}

public extension Graph {
    
    public convenience init<S: GraphData where S.GraphDataKey == T, S.GraphDataValue == U>(type: GraphType, data: [S], min minOrNil: U? = nil, max maxOrNil: U? = nil, textDisplayHandler: GraphTextDisplayHandler? = nil) {
        
        let range = {() -> GraphRange<U>? in
            if let min = minOrNil, let max = maxOrNil {
                return GraphRange(min: min, max: max)
            }
            return nil
        }
        
        self.init(type: type, data: data, range: range(), textDisplayHandler: textDisplayHandler)
    }
    
    public convenience init<S: GraphData where S.GraphDataKey == T, S.GraphDataValue == U>(type: GraphType, data: [S], range rangeOrNil: GraphRange<U>? = nil, textDisplayHandler: GraphTextDisplayHandler? = nil) {
        
        let r = {() -> GraphRange<U> in
            if let r = rangeOrNil { return r }
            let sorted = data.sort{ $0.value < $1.value }
            return GraphRange<U>(
                min: sorted.first?.value ?? U(0),
                max: sorted.last?.value ?? U(0)
            )
        }
        
        switch type {
        case .Bar:
            
            self.init(barGraph:BarGraph<T, U>(
                units: data.map{ GraphUnit<T, U>(key: $0.key, value: $0.value) },
                range: r(),
                textDisplayHandler: textDisplayHandler
                ))
            
        case .Line:
            
            self.init(lineGraph: LineGraph<T, U>(
                units: data.map{ GraphUnit<T, U>(key: $0.key, value: $0.value) },
                range: r(),
                textDisplayHandler: textDisplayHandler
                ))
            
        case .Pie:
            
            self.init(pieGraph: PieGraph<T, U>(
                units: data.map{ GraphUnit<T, U>(key: $0.key, value: $0.value) },
                textDisplayHandler: textDisplayHandler
                ))
        }
        
    }
    
    public convenience init(type: GraphType, array: [U], min minOrNil: U? = nil, max maxOrNil: U? = nil, textDisplayHandler: GraphTextDisplayHandler? = nil) {
        
        let range = {() -> GraphRange<U>? in
            if let min = minOrNil, let max = maxOrNil {
                return GraphRange(min: min, max: max)
            }
            return nil
        }
        
        self.init(type: type, array: array, range: range(), textDisplayHandler: textDisplayHandler)
    }
    
    public convenience init(type: GraphType, array: [U], range rangeOrNil: GraphRange<U>? = nil, textDisplayHandler: GraphTextDisplayHandler? = nil) {
        
        let r = {() -> GraphRange<U> in
            if let r = rangeOrNil { return r }
            let sorted = array.sort{ $0 < $1 }
            return GraphRange<U>(
                min: sorted.first ?? U(0),
                max: sorted.last ?? U(0)
            )
        }
        
        switch type {
        case .Bar:
            
            self.init(barGraph:BarGraph<T, U>(
                units: array.map{ GraphUnit<T, U>(key: nil, value: $0) },
                range: r(),
                textDisplayHandler: textDisplayHandler
            ))
            
        case .Line:
            
            self.init(lineGraph: LineGraph<T, U>(
                units: array.map{ GraphUnit<T, U>(key: nil, value: $0) },
                range: r(),
                textDisplayHandler: textDisplayHandler
            ))
            
        case .Pie:
            
            self.init(pieGraph: PieGraph<T, U>(
                units: array.map{ GraphUnit<T, U>(key: nil, value: $0) },
                textDisplayHandler: textDisplayHandler
            ))
        }
    }
}

public extension Graph {
    
    public convenience init(type: GraphType, dictionary: [T: U], min minOrNil: U? = nil, max maxOrNil: U? = nil, textDisplayHandler: GraphTextDisplayHandler? = nil) {
        
        let range = {() -> GraphRange<U>? in
            if let min = minOrNil, let max = maxOrNil {
                return GraphRange(min: min, max: max)
            }
            return nil
        }
        
        self.init(type: type, dictionary: dictionary, range: range(), textDisplayHandler: textDisplayHandler)
    }
    
    public convenience init(type: GraphType, dictionary: [T: U], range rangeOrNil: GraphRange<U>? = nil, textDisplayHandler: GraphTextDisplayHandler? = nil) {
        
        let sorted = dictionary.sort{ $0.1 < $1.1 }
        
        let r = {() -> GraphRange<U> in
            if let r = rangeOrNil { return r }

            return GraphRange<U>(
                min: sorted.first?.1 ?? U(0),
                max: sorted.last?.1 ?? U(0)
            )
        }
        
        switch type {
        case .Bar:
            
            self.init(barGraph:BarGraph<T, U>(
                units: sorted.map{ GraphUnit<T, U>(key: $0.0, value: $0.1) },
                range: r(),
                textDisplayHandler: textDisplayHandler
            ))
            
        case .Line:
            
            self.init(lineGraph: LineGraph<T, U>(
                units: sorted.map{ GraphUnit<T, U>(key: $0.0, value: $0.1) },
                range: r(),
                textDisplayHandler: textDisplayHandler
            ))
            
        case .Pie:
            
            self.init(pieGraph: PieGraph<T, U>(
                units: sorted.map{ GraphUnit<T, U>(key: $0.0, value: $0.1) },
                textDisplayHandler: textDisplayHandler
            ))
        }
    }
}

public extension Graph {
    
    public func view(frame: CGRect) -> GraphView<T, U> {
        return GraphView(frame: frame, graph: self)
    }
}

enum GraphKind<T: Hashable, U: NumericType> {
    case
    Bar(BarGraph<T, U>),
    Line(LineGraph<T, U>),
    Pie(PieGraph<T, U>)
    
    internal static func barGraph(units: [GraphUnit<T, U>], range: GraphRange<U>) -> GraphKind<T, U> {
        return GraphKind<T, U>.Bar(BarGraph(units: units, range: range))
    }
    
    internal static func lineGraph(units: [GraphUnit<T, U>], range: GraphRange<U>) -> GraphKind<T, U> {
        return GraphKind<T, U>.Line(LineGraph(units: units, range: range))
    }
    
    internal static func pieGraph(units: [GraphUnit<T, U>]) -> GraphKind<T, U> {
        return GraphKind<T, U>.Pie(PieGraph(units: units))
    }
}

public protocol GraphBase {
    
    associatedtype UnitsType
    associatedtype RangeType
    associatedtype GraphTextDisplayHandler
    
    var units: UnitsType { get }
    var textDisplayHandler: GraphTextDisplayHandler? { get }
}



internal struct BarGraph<T: Hashable, U: NumericType>: GraphBase {
    
    typealias GraphView = BarGraphView<T, U>
    typealias UnitsType = [GraphUnit<T, U>]
    typealias RangeType = GraphRange<U>
    typealias GraphTextDisplayHandler = Graph<T, U>.GraphTextDisplayHandler
    
    var units: [GraphUnit<T, U>]
    var range: GraphRange<U>
    var textDisplayHandler: GraphTextDisplayHandler?
    
    internal init(
        units: [GraphUnit<T, U>],
        range: GraphRange<U>,
        textDisplayHandler: GraphTextDisplayHandler? = nil
    ) {
        self.units = units
        self.range = range
        self.textDisplayHandler = textDisplayHandler
    }

    func view(frame: CGRect) -> GraphView? {
        return BarGraphView<T, U>(
            frame: frame,
            graph: self
        )
    }
    
    func graphTextDisplay() -> GraphTextDisplayHandler {
        if let f = textDisplayHandler {
            return f
        }
        return { (unit, total) -> String? in String(unit.value) }
    }
}

internal struct MultiBarGraph<T: Hashable, U: NumericType>: GraphBase {
    
    typealias UnitsType = [[GraphUnit<T, U>]]
    typealias RangeType = GraphRange<U>
    typealias GraphTextDisplayHandler = Graph<T, U>.GraphTextDisplayHandler
    
    var units: [[GraphUnit<T, U>]]
    var range: GraphRange<U>
    var textDisplayHandler: GraphTextDisplayHandler?
    
    func graphTextDisplay() -> GraphTextDisplayHandler {
        if let f = textDisplayHandler {
            return f
        }
        return { (unit, total) -> String? in String(unit.value) }
    }
}

internal struct LineGraph<T: Hashable, U: NumericType>: GraphBase {
    
    typealias GraphView = LineGraphView<T, U>
    typealias UnitsType = [GraphUnit<T, U>]
    typealias RangeType = GraphRange<U>
    typealias GraphTextDisplayHandler = Graph<T, U>.GraphTextDisplayHandler
    
    var units: [GraphUnit<T, U>]
    var range: GraphRange<U>
    var textDisplayHandler: GraphTextDisplayHandler?
    
    init(
        units: [GraphUnit<T, U>],
        range: GraphRange<U>,
        textDisplayHandler: GraphTextDisplayHandler? = nil
    ) {
        self.units = units
        self.range = range
        self.textDisplayHandler = textDisplayHandler
    }
    
    func view(frame: CGRect) -> GraphView? {
        return LineGraphView(frame: frame, graph: self)
    }
    
    func graphTextDisplay() -> GraphTextDisplayHandler {
        if let f = textDisplayHandler {
            return f
        }
        return { (unit, total) -> String? in String(unit.value) }
    }
}

internal struct PieGraph<T: Hashable, U: NumericType>: GraphBase {
    
    typealias GraphView = PieGraphView<T, U>
    typealias UnitsType = [GraphUnit<T, U>]
    typealias RangeType = GraphRange<U>
    typealias GraphTextDisplayHandler = Graph<T, U>.GraphTextDisplayHandler
    
    var units: [GraphUnit<T, U>]
    var textDisplayHandler: GraphTextDisplayHandler?
    
    init(
        units: [GraphUnit<T, U>],
        textDisplayHandler: GraphTextDisplayHandler? = nil
    ) {
        self.units = units
        self.textDisplayHandler = textDisplayHandler
    }
    
    func view(frame: CGRect) -> GraphView? {
        return PieGraphView(frame: frame, graph: self)
    }
    
    func graphTextDisplay() -> GraphTextDisplayHandler {
        if let f = textDisplayHandler {
            return f
        }
        return { (unit, total) -> String? in
            let f = unit.value.floatValue() / total.floatValue()
            return String(unit.value) + " : " + String(format: "%.0f%%", f * 100.0)
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
        
        assert(min <= max)
        
        self.min = min
        self.max = max
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
