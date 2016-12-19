//
//  Protocols.swift
//  Pods
//
//  Created by Felix Dumit on 9/14/15.
//
//
import CoreSpotlight

/**
*  Methods given for free when implementing :SpotlightConvertable:
*/
@available(*, deprecated, message: "Use EasySpotlight methods instead")
public protocol SpotlightIndexable {
    
    /**
    Add the item to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    
    func addToSpotlightIndex(_ completion:SpotlightCompletion)
    
    /**
    Remove the item to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    func removeFromSpotlightIndex(_ completion:SpotlightCompletion)
    
    /**
    Remove all objects of Type to spotlight search
    
    - parameter completion: block called when indexing finishes
    */
    static func removeAllFromSpotlightIndex(_ completion:SpotlightCompletion)
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
    var identifier:StringLiteralType {get}
    
    //optional
    var itemType:String {get}
    var thumbnailImage:UIImage? {get}
    func configure(searchableItem item:CSSearchableItem)
}

/**
*  Protocol that enables automatic handling when app is opened from a spotlight search
*/
public protocol SpotlightRetrievable:SpotlightConvertable {
    /**
    Function required for retrieving back the object from a given unique identifier.
    
    - parameter identifier: unique idenfitier of type to be fetched
    
    - returns: retrieved item
    */
    static func item(with identifier: String) -> Self?
}
