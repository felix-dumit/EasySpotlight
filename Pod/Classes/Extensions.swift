import MobileCoreServices
import CoreSpotlight

// optional parameters
@available(iOS 9.0, *)
public extension SpotlightConvertable {
    var thumbnailImage:UIImage? { return nil }
    func configureSearchableItem(item:CSSearchableItem) {
        // 100 years default expiration date
        item.expirationDate = NSDate(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 12 * 10)
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable {
    
    var itemType:String { return kUTTypeImage as String }
    
    static var domainIdentifier:String { return "\(Self.self)"}
    
    func indexableItem() -> CSSearchableItem {
        let set = CSSearchableItemAttributeSet(itemContentType: itemType)
        set.title = title
        if let img = thumbnailImage {
            set.thumbnailData = UIImageJPEGRepresentation(img, 0.9)
        }
        
        let item = CSSearchableItem(uniqueIdentifier: identifier, domainIdentifier: Self.domainIdentifier, attributeSet: set)
        
        configureSearchableItem(item)
        
        return item
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable/*:SpotlightIndexable*/ {
    
    func addToSpotlightIndex(completion:SpotlightCompletion = nil) {
        [self].addToSpotlightIndex(completion)
    }
    func removeFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        [self].removeFromSpotlightIndex(completion)
    }
    
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithDomainIdentifiers([domainIdentifier], completionHandler: completion)
    }
}



@available(iOS 9.0, *)
public extension CollectionType/*:SpotlightIndexable*/ where Generator.Element:SpotlightConvertable {
    func addToSpotlightIndex(completion:SpotlightCompletion = nil){
        let items = self.map{ $0.indexableItem() }
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(items, completionHandler: completion)
    }
    
    func removeFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        let ids = self.map { $0.identifier }
        CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(ids, completionHandler: completion)
    }
    
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion = nil) {
        CSSearchableIndex.defaultSearchableIndex().deleteAllSearchableItemsWithCompletionHandler(completion)
    }
}
