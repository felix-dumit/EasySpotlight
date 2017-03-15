![Image](http://i.imgur.com/wwmRaRR.png)

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=58c8e0590b654b0100584133&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/58c8e0590b654b0100584133/build/latest?branch=master)[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/EasySpotlight.svg?style=flat)](http://cocoapods.org/pods/EasySpotlight)
[![License](https://img.shields.io/cocoapods/l/EasySpotlight.svg?style=flat)](http://cocoapods.org/pods/EasySpotlight)
[![Platform](https://img.shields.io/cocoapods/p/EasySpotlight.svg?style=flat)](http://cocoapods.org/pods/EasySpotlight)

## Intro

EasySpotlight makes it easy to index contento to CoreSpotlight and handle app launches from Spotlight.

## Requirements
`CoreSpotlight` is only available in **iOS 9.0** or later 
## Installation

EasySpotlight is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "EasySpotlight"
```

Or through [Carthage](https://github.com/Carthage/Carthage) adding this to your Cartfile:
```
github "felix-dumit/EasySpotlight"
```

## Saving content to Spotlight

To use simply create a struct or class that implements the `SpotlightConvertable` protocol.
```swift 

@available(iOS 9.0, *)
// implement to enable indexing methods
public protocol SpotlightConvertable:SpotlightIndexable {
    var title:String? {get}
    var identifier:StringLiteralType {get}
    
    //optional
    var itemType:String {get}
    var thumbnailImage:UIImage? {get}
    func configure(searchableItem item:CSSearchableItem)
}
```


Here is a simple example of a struct that implements the protocol and becomes indexable.
```swift 
struct SimpleStruct:SpotlightConvertable {
    var title:String? = nil
    var identifier:String
}
```

You can now use all of the following methods:

```swift
let x = SimpleStruct(title:"Bob", identifier:"identifier")
EasySpotlight.index(x) { error in 
	handleError(error)
}
EasySpotlight.deIndex(x)
EasySpotlight.deIndexAll(of: SimpleStruct.self)
EasySpotlight.index([x])
```

If you want to further configure the `CSSearchableItem` and `CSSearchbleAttributeItemSet` properties you can implement the `configureSeachableItem` method in the protocol.

##Retrieving content

In order to easily handle when the app is opened via a spotlight search, you must implement the `SpotlightRetrievable` protocol: 

```swift 
public protocol SpotlightRetrievable:SpotlightConvertable {
    static func item(with identifier: String) -> Self?
}
```

Now you have to register a handler for that type in `application:didFinishLaunchingWithOptions:`:

```swift
EasySpotlight.registerIndexableHandler(SimpleStruct.self) { item in
   // handle when item is opened from spotlight
   assert(item is SimpleStruct)
   print("started with: \(item)")
}
```

Now all that is left is to implement the function called when the app opens from a spotlight search: 

```swift
func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
     return EasySpotlight.handle(activity: userActivity) || handleOtherUserActivities(userActivity)
}
```

## Usage

See the included example application for a sample that indexes and retrieves objects from `Realm`.

## Feedback
New feature ideas, suggestions, or any general feedback is greatly appreciated.

## Author

Felix Dumit, felix.dumit@gmail.com

## License

EasySpotlight is available under the MIT license. See the LICENSE file for more info.
