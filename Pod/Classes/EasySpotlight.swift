//
//  EasySpotlight.swift
//  Pods
//
//  Created by Felix Dumit on 9/20/15.
//
//

import CoreSpotlight


public struct EasySpotlight {
    
    /**
    Handle an NSUserActivity
    
    - parameter activity: activity that the app was opened from
    
    - returns: true if it was handled correctly and activitytype was `CSSearchableItemActionType`
    */
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
    
    /**
    Register a handler for when the app is opened due to selecting an item from the spotlight search
    
    - parameter type:  type being registered
    - parameter block: block executed when app is opened
    */
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

