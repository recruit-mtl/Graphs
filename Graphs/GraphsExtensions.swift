//
//  GraphsExtensions.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/05/31.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

/**
 GraphData protocols array can make 'Graph' object.
 */

public protocol GraphData {
    
    associatedtype GraphDataKey: Hashable
    associatedtype GraphDataValue: NumericType
    
    var key: GraphDataKey { get }
    var value: GraphDataValue { get }
}


/**
 SequenceType<S: GraphData> -> 'Graph' object
 */

extension Sequence where Iterator.Element: GraphData {
    
    typealias GraphDataKey = Iterator.Element.GraphDataKey
    typealias GraphDataValue = Iterator.Element.GraphDataValue
    
    public func barGraph(
        _ range: GraphRange<GraphDataValue>? = nil,
        textDisplayHandler: Graph<GraphDataKey, GraphDataValue>.GraphTextDisplayHandler? = nil
    ) -> Graph<Iterator.Element.GraphDataKey, Iterator.Element.GraphDataValue> {
        
        return Graph<GraphDataKey, GraphDataValue>(type: .bar, data: self.map{ $0 }, range: range, textDisplayHandler: textDisplayHandler)
    }
    
    public func lineGraph(
        _ range: GraphRange<GraphDataValue>? = nil,
        textDisplayHandler: Graph<GraphDataKey, GraphDataValue>.GraphTextDisplayHandler? = nil
    ) -> Graph<Iterator.Element.GraphDataKey, Iterator.Element.GraphDataValue> {
        
        return Graph<GraphDataKey, GraphDataValue>(type: .line, data: self.map{ $0 }, range: range, textDisplayHandler: textDisplayHandler)
    }
    
    public func pieGraph(
        _ textDisplayHandler: Graph<GraphDataKey, GraphDataValue>.GraphTextDisplayHandler? = nil
    ) -> Graph<Iterator.Element.GraphDataKey, Iterator.Element.GraphDataValue> {
        
        return Graph<GraphDataKey, GraphDataValue>(type: .pie, data: self.map{ $0 }, range: nil, textDisplayHandler: textDisplayHandler)
    }
}


/**
 SequenceType<S: NumericType> -> 'Graph' object
 */

extension Sequence where Iterator.Element: NumericType {
    
    public func barGraph(
        _ range: GraphRange<Iterator.Element>? = nil,
        textDisplayHandler: Graph<String, Iterator.Element>.GraphTextDisplayHandler? = nil
    ) -> Graph<String, Iterator.Element> {
        
        return Graph<String, Iterator.Element>(type: .bar, array: self.map{ $0 }, range: range, textDisplayHandler: textDisplayHandler)
    }
    
    
    public func lineGraph(
        _ range: GraphRange<Iterator.Element>? = nil,
        textDisplayHandler: Graph<String, Iterator.Element>.GraphTextDisplayHandler? = nil
    ) -> Graph<String, Iterator.Element> {
        
        return Graph<String, Iterator.Element>(type: .line, array: self.map{ $0 }, range: range, textDisplayHandler: textDisplayHandler)
    }
    
    
    public func pieGraph(
        _ textDisplayHandler: Graph<String, Iterator.Element>.GraphTextDisplayHandler? = nil
    ) -> Graph<String, Iterator.Element> {
        
        return Graph<String, Iterator.Element>(type: .pie, array: self.map{ $0 }, range: nil, textDisplayHandler: textDisplayHandler)
    }
    
}


/**
 Dictionary -> 'Graph' object
 */

extension Collection where Self: ExpressibleByDictionaryLiteral, Self.Key: Hashable, Self.Value: NumericType, Iterator.Element == (Self.Key, Self.Value) {
    
    
    typealias aKey = Self.Key
    typealias aValue = Self.Value
    
    public func barGraph(
        _ range: GraphRange<aValue>? = nil,
        sort: (((Self.Key, Self.Value), (Self.Key, Self.Value)) -> Bool)? = nil,
        textDisplayHandler: Graph<aKey, aValue>.GraphTextDisplayHandler? = nil
    ) -> Graph<aKey, aValue> {
        
        return Graph<aKey, aValue>(type: .bar, dictionary: dict(), range: range, textDisplayHandler: textDisplayHandler)
    }
    
    public func lineGraph(
        _ range: GraphRange<aValue>? = nil,
        sort: (((Self.Key, Self.Value), (Self.Key, Self.Value)) -> Bool)? = nil,
        textDisplayHandler: Graph<aKey, aValue>.GraphTextDisplayHandler? = nil
        ) -> Graph<aKey, aValue> {
        
        return Graph<aKey, aValue>(type: .line, dictionary: dict(), range: range, textDisplayHandler: textDisplayHandler)
    }
    
    public func pieGraph(
        _ range: GraphRange<aValue>? = nil,
        sort: (((Self.Key, Self.Value), (Self.Key, Self.Value)) -> Bool)? = nil,
        textDisplayHandler: Graph<aKey, aValue>.GraphTextDisplayHandler? = nil
        ) -> Graph<aKey, aValue> {
        
        return Graph<aKey, aValue>(type: .pie, dictionary: dict(), range: nil, textDisplayHandler: textDisplayHandler)
    }
    
    func dict() -> [aKey: aValue] {
        var d = [aKey: aValue]()
        for kv in self {
            d[kv.0] = kv.1
        }
        return d
    }
    
    func touples() -> [(aKey, aValue)] {
        var d = [(aKey, aValue)]()
        for kv in self {
            d.append((kv.0, kv.1))
        }
        return d
    }
    
}


extension Array {
    var match : (head: Element, tail: [Element])? {
        return (count > 0) ? (self[0],Array(self[1..<count])) : nil
    }
}

enum DefaultColorType {
    case bar, line, barText, lineText, pieText
    
    func color() -> UIColor {
        switch self {
        case .bar:      return UIColor(hex: "#4DC2AB")
        case .line:     return UIColor(hex: "#FF0066")
        case .barText:  return UIColor(hex: "#333333")
        case .lineText: return UIColor(hex: "#333333")
        case .pieText:  return UIColor(hex: "#FFFFFF")
        }
    }
    
    static func pieColors(_ count: Int) -> [UIColor] {
        
        func randomArray(_ arr: [Int]) -> [Int] {
            if arr.count <= 0 {
                return []
            }
            let randomIndex = Int(arc4random_uniform(UInt32(arr.count)))
            var tail = [Int]()
            for i in 0 ..< arr.count {
                if i != randomIndex {
                    tail.append(arr[i])
                }
            }
            return [arr[randomIndex]] + randomArray(tail)
        }
        
        return Array(0 ..< count).map({ $0 }).map({ UIColor(hue: CGFloat($0) / CGFloat(count), saturation: 0.9, brightness: 0.9, alpha: 1.0) })
    }
}

public extension UIColor {
    
    convenience init(RGBInt: UInt64, alpha: Float = 1.0) {
        self.init(
            red: (((CGFloat)((RGBInt & 0xFF0000) >> 16)) / 255.0),
            green: (((CGFloat)((RGBInt & 0xFF00) >> 8)) / 255.0),
            blue: (((CGFloat)(RGBInt & 0xFF)) / 255.0),
            alpha: CGFloat(alpha)
        )
    }
    
    convenience init(hex: String) {
        
        let prefixHex = {(str) -> String in
            for prefix in ["0x", "0X", "#"] {
                if str.hasPrefix(prefix) {
                    return str.substring(from: str.characters.index(str.startIndex, offsetBy: prefix.characters.count))
                }
            }
            return str
        }(hex)
        
        
        if prefixHex.characters.count != 6 && prefixHex.characters.count != 8 {
            self.init(white: 0.0, alpha: 1.0)
            return
        }
        
        let scanner = Scanner(string: prefixHex)
        var hexInt: UInt64 = 0
        if !scanner.scanHexInt64(&hexInt) {
            self.init(white: 0.0, alpha: 1.0)
            return
        }
        
        switch prefixHex.characters.count {
        case 6:
            self.init(RGBInt: hexInt)
        case 8:
            self.init(RGBInt: hexInt >> 8, alpha: (((Float)(hexInt & 0xFF)) / 255.0))
        case _:
            self.init(white: 0.0, alpha: 1.0)
        }
    }
}

public extension UIEdgeInsets {
    
//    public init(all: CGFloat) {
//        self.left = all
//        self.right = self.left
//        self.top = self.left
//        self.bottom = self.left
//    }
    
    public func verticalMarginsTotal() -> CGFloat {
        return self.top + self.bottom
    }
    
    public func horizontalMarginsTotal() -> CGFloat {
        return self.left + self.right
    }
}

extension NSAttributedString {
    
    class func graphAttributedString(_ string: String, color: UIColor, font: UIFont) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        return NSAttributedString(string: string, attributes: [
            NSForegroundColorAttributeName:color,
            NSFontAttributeName: font,
            NSParagraphStyleAttributeName: paragraph
        ])
    }
}



