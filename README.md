# EasySpotlight

[![CI Status](http://img.shields.io/travis/felix-dumit/EasySpotlight.svg?style=flat)](https://travis-ci.org/Felix Dumit/EasySpotlight)
[![Version](https://img.shields.io/cocoapods/v/EasySpotlight.svg?style=flat)](http://cocoapods.org/pods/EasySpotlight)
[![License](https://img.shields.io/cocoapods/l/EasySpotlight.svg?style=flat)](http://cocoapods.org/pods/EasySpotlight)
[![Platform](https://img.shields.io/cocoapods/p/EasySpotlight.svg?style=flat)](http://cocoapods.org/pods/EasySpotlight)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

EasySpotlight is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EasySpotlight"
```

## Usage 

To use simply create a struct or class that implements the `SpotlightConvertable` protocol, and you will get the methods defined in `SpotlightIndexable` for free.
Both protocols are copied **verbatum** below.

```swift 
public typealias SpotlightCompletion = ((NSError?) -> Void)?

//methods given for free
public protocol SpotlightIndexable {
    func addToSpotlightIndex(completion:SpotlightCompletion)
    func removeFromSpotlightIndex(completion:SpotlightCompletion)
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion)
}

@available(iOS 9.0, *)
// implement to enable indexing methods
public protocol SpotlightConvertable:SpotlightIndexable {
    var title:String? {get}
    var identifier:String {get}
    
    //optional
     var itemType:String {get}
    var thumbnailImage:UIImage? {get}
    func configureSearchableItem(item:CSSearchableItem)
}
```


Here is a simple exable of a struct that implements the protocol and becomes indexable. Note also that arrays of `[SpotlightConvertable]` also conform to `SpotlightIndexable`

```swift 
struct SimpleStruct:SpotlightConvertable {
    var title:String? = nil
    var identifier:String
}
```

You can now use all of the following methods:

```swift
let x = SimpleStruct(title:"Bob", identifier:"identifier")

x.addToSpotlightIndex() { error in 
	//
}
x.removeFromSpotlightIndex()
SimpleStruct.removeAllFromSpotlightIndex()
[x].addToSpotlightIndex()

```

If you want to further configure the `CSSearchableItem` and `CSSearchbleAttributeItemSet` properties you can implement the `configureSeachableItem` method in the protocol.

## TODO
Implement way to easily handle when user opens app from a core spotlight search.

## Feedback
New feature ideas, suggestions, or any general feedback is greatly appreciated.

## Author

Felix Dumit, felix.dumit@gmail.com

## License

EasySpotlight is available under the MIT license. See the LICENSE file for more info.
