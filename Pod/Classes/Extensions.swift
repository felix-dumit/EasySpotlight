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
    func configureSearchableItem(item:CSSearchableItem) {
        // 100 years default expiration date
        item.expirationDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 12 * 10)
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable {
    
    var itemType:String { return kUTTypeImage as String }
    
    static var domainIdentifier:String { return "\(Self.self)"}
    
    internal var uniqueIdentifier:String {
        return EasySpotlight.compositeIdentifier(identifier, domain: Self.domainIdentifier)
    }
    
    internal func indexableItem() -> CSSearchableItem {
        let set = CSSearchableItemAttributeSet(itemContentType: itemType)
        set.title = title
        set.contentDescription = contentDescription
        if let img = thumbnailImage {
            set.thumbnailData = UIImageJPEGRepresentation(img, 0.9)
        }
        
        let item = CSSearchableItem(uniqueIdentifier: uniqueIdentifier, domainIdentifier: Self.domainIdentifier, attributeSet: set)
        
        configureSearchableItem(item)
        
        return item
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable/*:SpotlightIndexable*/ {
    
    /**
    Add the item to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    func addToSpotlightIndex(completion:SpotlightCompletion = nil) {
        [self].addToSpotlightIndex(completion)
    }
    
    /**
    Removes item from spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    func removeFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        [self].removeFromSpotlightIndex(completion)
    }
    
    /**
    Removes all objects of the Type from spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        EasySpotlight.searchableIndex.deleteSearchableItemsWithDomainIdentifiers([domainIdentifier], completionHandler: completion)
    }
}

@available(iOS 9.0, *)
public extension CollectionType/*:SpotlightIndexable*/ where Generator.Element:SpotlightConvertable {
    
    /**
    Add all objects in collection to spotlight
    
    - parameter completion: block called when indexing finishes
    */
    func addToSpotlightIndex(completion:SpotlightCompletion = nil){
        let items = self.map{ $0.indexableItem() }
        EasySpotlight.searchableIndex.indexSearchableItems(items, completionHandler: completion)
    }
    
    /**
    Removes all objects in collection from spotlight
    
    - parameter completion: block called when indexing finishes
    */
    func removeFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        let ids = self.map { $0.uniqueIdentifier }
        EasySpotlight.searchableIndex.deleteSearchableItemsWithIdentifiers(ids, completionHandler: completion)
    }
    
    /**
    Remove every single object from spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        EasySpotlight.searchableIndex.deleteAllSearchableItemsWithCompletionHandler(completion)
    }
}
