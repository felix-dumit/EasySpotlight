//
//  EasySpotlight.swift
//  Pods
//
//  Created by Felix Dumit on 9/20/15.
//
//

import CoreSpotlight

public typealias SpotlightCompletion = ((Error?) -> Void)?

public struct EasySpotlight {

    /// Index the item to CoreSpotlight
    ///
    /// - Parameters:
    ///   - item: the item to be indexed
    ///   - completion: called when indexing finishes
    public static func index(_ item: SpotlightConvertable, completion: SpotlightCompletion = nil) {
        index([item], completion: completion)
    }

    /// Index the items to CoreSpotlight
    ///
    /// - Parameters:
    ///   - items: the items to be indexed
    ///   - completion: called when indexing finishes
    public static func index(_ items: [SpotlightConvertable], completion: SpotlightCompletion = nil) {
        let items = items.map { $0.indexableItem() }
        searchableIndex.indexSearchableItems(items, completionHandler: completion)
    }

    /// Remove an item from CoreSpotlight
    ///
    /// - Parameters:
    ///   - item: item to be removed
    ///   - completion: called when deindexing finishes
    public static func deIndex(_ item: SpotlightConvertable, completion: SpotlightCompletion = nil) {
        deIndex([item], completion: completion)
    }

    /// Remove items from CoreSpotlight
    ///
    /// - Parameters:
    ///   - items: items to be deindex
    ///   - completion: called when deindexing finishes
    public static func deIndex(_ items: [SpotlightConvertable], completion: SpotlightCompletion = nil) {
        let ids = items.map { $0.uniqueIdentifier }
        searchableIndex.deleteSearchableItems(withIdentifiers: ids, completionHandler: completion)
    }

    /// Removes all CoreSpotlight indexes from a specific type
    ///
    /// - Parameters:
    ///   - type: the type that all indexes will be removed
    ///   - completion: called when deindexing finishes
    public static func deIndexAll<T: SpotlightConvertable>(of type: T.Type, completion: SpotlightCompletion = nil) {
        searchableIndex.deleteSearchableItems(withDomainIdentifiers: [type.domainIdentifier],
                                              completionHandler: completion)
    }

    /// Handle an NSUserAcitivity
    ///
    /// - Parameter activity: activity that the app was opened from
    /// - Returns: true if it was handled correctly and activitytype was `CSSearchableItemActionType`
    @discardableResult
    public static func handle(activity: NSUserActivity?) -> Bool {
        guard activity?.activityType == CSSearchableItemActionType else {
            return false
        }

        guard let uniqueId = activity?.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
            return false
        }

        let (domain, identifier) = IdentifierGenerator.decombineFromUniqueIdentifier(uniqueId)

        guard let register = typeDict[domain] else { return false }

        DispatchQueue.global(qos: .userInitiated).async {
            let itemCreator = try? register.type.retrieveItem(with: identifier)
            register.queue.async {
                if let item = try? itemCreator?() {
                    register.callback(item)
                }
            }
        }

        return true
    }

    /// Register a handler for when the app is opened due to selecting an item from the spotlight search
    ///
    /// - Parameters:
    ///   - type: type being registered
    ///   - block: block executed when app is opened
    public static func registerIndexableHandler<T: SpotlightRetrievable>(_ type: T.Type,
                                                                         queue: DispatchQueue = .main,
                                                                         block:@escaping ((T) -> Void)) {
        let specializedCallback = { (value: T?) -> Void in
            if let value = value {
                block(value)
            }
        }

        let callback = GenericCallback(callback: specializedCallback).executeCallback
        typeDict[T.domainIdentifier] = EasySpotlightRegister(type: T.self, callback: callback, queue: queue)

    }

    private static var typeDict: [String: EasySpotlightRegister] = [:]
    public static var searchableIndex = CSSearchableIndex.default()
}

private struct EasySpotlightRegister {
    let type: SpotlightRetrievable.Type
    let callback: GenericCallbackType
    let queue: DispatchQueue
}
