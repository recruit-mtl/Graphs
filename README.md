#<img src="https://s3-ap-northeast-1.amazonaws.com/graphs-mtl/graphs_logo.png" width="100%" alt="Graphs" />
[![Badge w/ Version](https://cocoapod-badges.herokuapp.com/v/Graphs/badge.png)](https://cocoadocs.org/docsets/MTLLinkLabel)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

###Light weight charts view generater for iOS. Written in Swift.

<img src="https://s3-ap-northeast-1.amazonaws.com/graphs-mtl/graphs_mock.png" width="850" alt="Graphs mock" />

## Requirements
- iOS 8.0+
- XCode 7.3+

## Installation
### [CocoaPods](https://cocoapods.org)
```bash
$ pod init
```

specify it in your `Podfile`

```ruby
platform :ios, '8.0'

target 'TargetName' do

  use_frameworks!
  pod 'Graphs', '~> 0.1.2'

end
```

And run `CocoaPods`

```bash
$ pod install
```

--
### [Carthage](https://github.com/Carthage/Carthage)
You can install Carthage with Homebrew.

```bash
$ brew update
$ brew install carthage
```
specify it in your `Cartfile`

```
github "recruit-mtl/Graphs"
```

And run `carthage`

```bash
$ carthage update --platform ios
```

## Usage

#####import Graphs
```swift
import Graphs
```

##### Range -> GraphView (Bar)
```swift
let view = (1 ... 10).barGraph(GraphRange(min: 0, max: 11)).view(viewFrame)
```
<img src="https://s3-ap-northeast-1.amazonaws.com/graphs-mtl/graphs1.png" width="363" />

##### Array -> GraphView (Line)
```swift
let view = [10, 20, 4, 8, 25, 18, 21, 24, 8, 15].lineGraph(GraphRange(min: 0, max: 30)).view(viewFrame)
```
<img src="https://s3-ap-northeast-1.amazonaws.com/graphs-mtl/graphs2.png" width="349" />

##### Dictionary -> GraphView (Pie)
```swift
let view = ["a": 3, "b": 8, "c": 9, "d": 20].pieGraph().view(viewFrame)
```

##### GraphData protocol -> GraphView (Pie)
```swift
import Graphs

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

let view = data.pieGraph() { (unit, totalValue) -> String? in
    return unit.key! + "\n" + String(format: "%.0f%%", unit.value / totalValue * 100.0)
}.view(viewFrame)
```
<img src="https://s3-ap-northeast-1.amazonaws.com/graphs-mtl/graphs3.png" width="323	" />

##### More detail
-> Read Playgrounds

## Demo

```bash
$ git clone https://github.com/recruit-mtl/Graphs.git
$ cd /path/to/Graphs/GraphsExample
$ pod install
```
And Open ```GraphsExample.xcworkspace```

## Issues
### GraphView doesn't work on Interface builder.
Interface Builder talks to code through the ObjC runtime. 
And ObjC doesn't do generics.

## Licence

[MIT](https://github.com/recruit-mtl/MTLLinkLabel/blob/master/LICENSE)

## Author
- [kokoron: Twitter](https://twitter.com/kokoron)
- [kokoron: github](https://github.com/kokoron)
