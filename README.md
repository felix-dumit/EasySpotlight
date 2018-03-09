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
/**
*  Protocol that enables types to be saved to spotlight search
*/
public protocol SpotlightConvertable {

/// title displayed in search
var title: String? {get}

/// content description displayed in search
var contentDescription: String? {get}

/// unique idenfitier
var identifier: String {get}

//optional
var itemType: String {get}
var thumbnailImage: UIImage? {get}
func configure(searchableItem item: CSSearchableItem)
}
```


Here is a simple example of a struct that implements the protocol and becomes indexable.

```swift 
struct SimpleStruct: SpotlightConvertable {
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

## Retrieving content

In order to easily handle when the app is opened via a spotlight search, you must implement the `SpotlightRetrievable` protocol.

There is also a helper `SpotlightSyncRetrievable` protocol in case your retrieval code is thread safe and you do not need the retrieving code to be executed on the same queue as the fetched item will be consumed on or not.

### Sync / Thread Safe
Here is the simple example:

```swift
extension SimpleStruct: SpotlightSyncRetrievable {
    static func retrieveItem(with identifier: String) throws -> SimpleStruct? {
        return SimpleStruct(title: "item_\(identifier)", contentDescription: "cool", identifier: identifier)
    }
}
```
The method will be called in a background queue and then your registered handler will be called in the registered queue.

### Async / Not thread safe
But if you are using something like Realm to save your objects (not thread safe), you need something like:

```swift

extension SimpleRealmClass: SpotlightRetrievable {
    static func retrieveItem(with identifier: String) throws -> (() throws -> SimpleRealmClass?) {
        let obj = try Realm().object(ofType: self, forPrimaryKey: identifier)
        let safe = obj.map { ThreadSafeReference(to: $0) }
        return {
            guard let safe = safe else { return nil }
            return try Realm().resolve(safe)
        }
    }
}
```
The method is still called in a background queue, but the returned closure will be executed in the same queue as the registered handler.


### Register handler
Now you have to register a handler for that type in `application:didFinishLaunchingWithOptions:`:

```swift
EasySpotlight.registerIndexableHandler(SimpleStruct.self, queue: .main) { item in
   // handle when item is opened from spotlight
   assert(item is SimpleStruct)
   print("started with: \(item)")
}
```
The queue parameter is optional and defaults to `.main`

### Handle UserActivity
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
