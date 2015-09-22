//
//  Protocols.swift
//  Pods
//
//  Created by Felix Dumit on 9/14/15.
//
//
import CoreSpotlight

public typealias SpotlightCompletion = ((NSError?) -> Void)?

/**
*  Methods given for free when implementing :SpotlightConvertable:
*/
public protocol SpotlightIndexable {
    
    /**
    Add the item to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    func addToSpotlightIndex(completion:SpotlightCompletion)
    
    /**
    Remove the item to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    func removeFromSpotlightIndex(completion:SpotlightCompletion)
    
    /**
    Remove all objects of Type to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion)
}

@available(iOS 9.0, *)
/**
*  Protocol that enables types to be saved to spotlight search
*/
public protocol SpotlightConvertable:SpotlightIndexable {
    
    /// title displayed in search
    var title:String? {get}
    
    /// content description displayed in search
    var contentDescription:String? {get}
    
    /// unique idenfitier
    var identifier:String {get}
    
    //optional
    var itemType:String {get}
    var thumbnailImage:UIImage? {get}
    func configureSearchableItem(item:CSSearchableItem)
}

/**
*  Protocol that enables automatic handling when app is opened from a spotlight search
*/
public protocol SpotlightRetrievable:SpotlightConvertable {
    /**
    Function required for retrieving object from a given unique identifier.
    Will be called in a background thread.
    
    - parameter identifier: unique idenfitier of type to be fetched
    
    - returns: retrieved item
    */
    static func itemWithIdentifier(identifier: String) -> Self?
}