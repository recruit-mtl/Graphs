//
//  GraphsExtensions.swift
//  Graphs
//
//  Created by HiraiKokoro on 2016/05/31.
//  Copyright © 2016年 Recruit Holdings Co., Ltd. All rights reserved.
//

import UIKit

extension SequenceType where Generator.Element: NumericType {
    
    public func barGraph(range: GraphRange<Generator.Element>? = nil) -> Graph<String, Generator.Element> {
        
        let a = self.sort{ $0 < $1 }
        
        return Graph(barGraph: BarGraph<String, Generator.Element>(
            units: self.units(),
            range: range ?? GraphRange<Generator.Element>(
                min: a.first ?? Generator.Element(),
                max: a.last ?? Generator.Element()
            ))
        )
    }
    
    
    public func lineGraph(range: GraphRange<Generator.Element>? = nil) -> Graph<String, Generator.Element> {
        let a = self.sort{ $0 < $1 }
        
        return Graph(lineGraph: LineGraph<String, Generator.Element>(
            units: self.units(),
            range: range ?? GraphRange<Generator.Element>(
                min: a.first ?? Generator.Element(),
                max: a.last ?? Generator.Element()
            ))
        )
        
    }
    
    public func pieGraph() -> Graph<String, Generator.Element> {
        return Graph(pieGraph: PieGraph<String, Generator.Element>(units: self.units()))
    }
    
    func units<T: Hashable, U: NumericType>() -> [GraphUnit<T, U>] {
        return self.map{ GraphUnit<T, U>(key: nil, value: $0 as! U) }
    }
}

extension SequenceType where Generator.Element: SequenceType {
    
//    public func multiBarGraph(config: MultiBarGraphConfig<>? = nil) -> MultiBarGraph<Generator.Element> {
//        let a = self.sort{ $0 < $1 }
//        let graph = MultiBarGraph<Generator.Element>(
//            units: self.units(),
//            config: config ?? BarGraphConfig<Generator.Element>(
//                minimumValue: a.first ?? Generator.Element(),
//                maximumValue: a.last ?? Generator.Element()
//            )
//        )
//        return graph
//    }
}

enum DefaultColorType {
    case Bar, Line, BarText, LineText
    
    func color() -> UIColor {
        switch self {
        case .Bar:      return UIColor(hex: "#4DC2AB")
        case .Line:     return UIColor(hex: "#FF0066")
        case .BarText:  return UIColor(hex: "#333333")
        case .LineText: return UIColor(hex: "#333333")
        }
    }
    
    static func pieColors(count: Int) -> [UIColor] {
        return Array(0 ..< count).map({ $0 * 16 }).map({ UIColor(RGBInt: UInt64($0)) })
    }
}

extension UIColor {
    
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
                    return str.substringFromIndex(str.startIndex.advancedBy(prefix.characters.count))
                }
            }
            return str
        }(hex)
        
        
        if prefixHex.characters.count != 6 && prefixHex.characters.count != 8 {
            self.init(white: 0.0, alpha: 1.0)
            return
        }
        
        let scanner = NSScanner(string: prefixHex)
        var hexInt: UInt64 = 0
        if !scanner.scanHexLongLong(&hexInt) {
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



