# Graphs
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

####Light weight charts view generater for iOS.

## Requirements
- iOS 8.0+
- XCode 7.3+

## Installation
### [CocoaPods](https://cocoapods.org)

### [Carthage](https://github.com/Carthage/Carthage)

## Usage

#####import Graphs
```swift
import Graphs
```

##### Range -> GraphView (Bar)
```swift
let view = (1 ... 10).barGraph().view(viewFrame)
```
TODO: picture

##### Array -> GraphView (Line)
```swift
let view = [3, 8, 9, 20, 4, 6, 10].lineGraph().view(viewFrame)
```
TODO: picture

##### Dictionary -> GraphView (Pie)
```swift
let view = ["a": 3, "b": 8, "c": 9, "d": 20].pieGraph().view(viewFrame)
```
TODO: picture

##### More detail
-> Read Playgrounds

## Licence

[MIT](https://github.com/recruit-mtl/MTLLinkLabel/blob/master/LICENSE)

## Author
- [kokoron: Twitter](https://twitter.com/kokoron)
- [kokoron: github](https://github.com/kokoron)