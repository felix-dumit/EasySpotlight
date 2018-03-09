//
//  Protocols.swift
//  Pods
//
//  Created by Felix Dumit on 9/14/15.
//
//
import CoreSpotlight

@available(iOS 9.0, *)
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

/**
* Protocol that enables automatic handling when app is opened from a spotlight search
* Implement this if your type requires code to be executed in the same queue as consumer of call
*/
public protocol SpotlightRetrievable: SpotlightConvertable {
    /**
     Function required for retrieving back the object from a given unique identifier.
     
     - parameter identifier: unique idenfitier of type to be fetched
     
     - returns: closure that retrieves object.
     The function will be called in a background thread and the returned closure will then be called in the main thread.
     This is relevant if your objects are not thread self (e.g. Realm.Object)
     */
    static func retrieveItem(with identifier: String) throws -> (() throws -> Self?)
}

/**
*  Protocol that enables automatic handling when app is opened from a spotlight search
*  Implement this protocol if the retrieval of an item given an id is done in sync and is thread safe.
*/
public protocol SpotlightSyncRetrievable: SpotlightRetrievable {
    /**
     Function required for retrieving back the object from a given unique identifier.
     
     - parameter identifier: unique idenfitier of type to be fetched
     
     - returns: retrieved item
     */
    static func retrieveItem(with identifier: String) throws -> Self?
}
