import MobileCoreServices
import CoreSpotlight

// optional parameters
@available(iOS 9.0, *)
public extension SpotlightConvertable {

    /// Thumbnail image displayed in search results
    var thumbnailImage: UIImage? { return nil }

    /**
    Customize the attributes of :CSSearchableItem: before saving to spotlight

    - parameter item: item to configure that will be saved
    */
    func configure(searchableItem item: CSSearchableItem) {
        // 100 years default expiration date
        item.expirationDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 30 * 12 * 10)
    }
}

@available(iOS 9.0, *)
public extension SpotlightConvertable {

    var itemType: String { return kUTTypeImage as String }

    static var domainIdentifier: String { return "\(Self.self)"}

    internal var uniqueIdentifier: String {
        return IdentifierGenerator.combineIntoUniqueIdentifier(identifier.description, domain: Self.domainIdentifier)
    }

    internal func indexableItem() -> CSSearchableItem {
        let set = CSSearchableItemAttributeSet(itemContentType: itemType)
        set.title = title
        set.contentDescription = contentDescription
        if let img = thumbnailImage {
            set.thumbnailData = UIImageJPEGRepresentation(img, 0.9)
        }

        let item = CSSearchableItem(uniqueIdentifier: uniqueIdentifier,
                                    domainIdentifier: Self.domainIdentifier,
                                    attributeSet: set)

        configure(searchableItem: item)

        return item
    }
}

public extension SpotlightSyncRetrievable {
    static func retrieveItem(with identifier: String) throws -> (() throws -> Self?) {
        let item = try retrieveItem(with: identifier)
        return { item }
    }
}
