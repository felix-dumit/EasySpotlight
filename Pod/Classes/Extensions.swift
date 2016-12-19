import MobileCoreServices
import CoreSpotlight

// optional parameters
@available(iOS 9.0, *)
public extension SpotlightConvertable {

    /// Thumbnail image displayed in search results
    var thumbnailImage:UIImage? { return nil }

    /**
    Customize the attributes of :CSSearchableItem: before saving to spotlight

    - parameter item: item to configure that will be saved
    */
    func configure(searchableItem item:CSSearchableItem) {
        // 100 years default expiration date
        item.expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 12 * 10)
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable {

    var itemType:String { return kUTTypeImage as String }

    static var domainIdentifier:String { return "\(Self.self)"}

    internal var uniqueIdentifier:String {
        return EasySpotlight.composite(identifier: identifier.description, domain: Self.domainIdentifier)
    }

    internal func indexableItem() -> CSSearchableItem {
        let set = CSSearchableItemAttributeSet(itemContentType: itemType)
        set.title = title
        set.contentDescription = contentDescription
        if let img = thumbnailImage {
            set.thumbnailData = UIImageJPEGRepresentation(img, 0.9)
        }

        let item = CSSearchableItem(uniqueIdentifier: uniqueIdentifier, domainIdentifier: Self.domainIdentifier, attributeSet: set)

        configure(searchableItem: item)

        return item
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable/*:SpotlightIndexable*/ {

    /**
    Add the item to spotlight search

    - parameter completion: block called when indexing finishes
    */
    @available(*, deprecated, message: "Use EasySpotlight.index instead")
    func addToSpotlightIndex(_ completion:SpotlightCompletion = nil) {
        EasySpotlight.index(self, completion: completion)
    }

    /**
    Removes item from spotlight search

    - parameter completion: block called when indexing finishes
    */
    @available(*, deprecated, message: "Use EasySpotlight.deIndex instead")
    func removeFromSpotlightIndex(_ completion:SpotlightCompletion = nil) {
        EasySpotlight.deIndex(self, completion: completion)
    }

    /**
    Removes all objects of the Type from spotlight search

    - parameter completion: block called when indexing finishes
    */
    @available(*, deprecated, message: "Use EasySpotlight.deIndexAll instead")
    static func removeAllFromSpotlightIndex(_ completion:SpotlightCompletion = nil) {
        EasySpotlight.deIndexAll(of: self, completion: completion)
    }
}

@available(iOS 9.0, *)
public extension Collection/*:SpotlightIndexable*/ where Iterator.Element:SpotlightConvertable {

    /**
    Add all objects in collection to spotlight

    - parameter completion: block called when indexing finishes
    */
    @available(*, deprecated, message: "Use EasySpotlight.index instead")
    func addToSpotlightIndex(_ completion:SpotlightCompletion = nil){
        EasySpotlight.index(Array(self), completion: completion)
    }

    /**
    Removes all objects in collection from spotlight

    - parameter completion: block called when indexing finishes
    */
    @available(*, deprecated, message: "Use EasySpotlight.deIndex instead")
    func removeFromSpotlightIndex(_ completion:SpotlightCompletion = nil) {
        EasySpotlight.deIndex(Array(self), completion: completion)
    }
}
