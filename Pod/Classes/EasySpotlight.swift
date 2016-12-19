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
    public static func deIndexAll<T:SpotlightConvertable>(of type: T.Type, completion:SpotlightCompletion = nil) {
        searchableIndex.deleteSearchableItems(withDomainIdentifiers: [type.domainIdentifier], completionHandler: completion)
    }
    
    
    /// Handle an NSUserAcitivity
    ///
    /// - Parameter activity: activity that the app was opened from
    /// - Returns: true if it was handled correctly and activitytype was `CSSearchableItemActionType`
    @discardableResult
    public static func handle(activity:NSUserActivity?) -> Bool{
        guard activity?.activityType == CSSearchableItemActionType else {
            return false
        }
        
        guard let idDomain = activity?.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
            return false
        }
        
        let ids = decompose(composite: idDomain)
        
        guard let (objType, block) = typeDict[ids.domain] else { return false }
        
        let item = objType.item(with: ids.identifier)
        
        block(item)
        return true
    }
    
    
    /// Register a handler for when the app is opened due to selecting an item from the spotlight search
    ///
    /// - Parameters:
    ///   - type: type being registered
    ///   - block: block executed when app is opened
    public static func registerIndexableHandler<T:SpotlightRetrievable>(_ type:T.Type, block:@escaping ((T) -> Void)) {
        let specializedCallback = { (value: T?) -> Void in
            if let v = value {
                block(v)
            }
        }
        
        typeDict[T.domainIdentifier] = (T.self, GenericCallback(callback: specializedCallback).executeCallback)
    }
    
    internal static let separator = "|__|"
    
    internal static func composite(identifier:String, domain:String) -> String {
        return "\(domain)\(separator)\(identifier)"
    }
    
    internal static func decompose(composite:String) -> (domain:String, identifier:String) {
        let comps = composite.components(separatedBy: separator)
        return (comps[0], comps[1])
    }
    
    private typealias EasySpotlightRegister = (SpotlightRetrievable.Type, GenericCallbackType)
    private static var typeDict:[String:EasySpotlightRegister] = [:]
    public static var searchableIndex = CSSearchableIndex.default()
}
