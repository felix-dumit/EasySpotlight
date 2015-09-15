//
//  Protocols.swift
//  Pods
//
//  Created by Felix Dumit on 9/14/15.
//
//
import CoreSpotlight

public typealias SpotlightCompletion = ((NSError?) -> Void)?

//methods given for free
public protocol SpotlightIndexable {
    func addToSpotlightIndex(completion:SpotlightCompletion)
    func removeFromSpotlightIndex(completion:SpotlightCompletion)
    static func removeAllFromSpotlightIndex(completion:SpotlightCompletion)
}

@available(iOS 9.0, *)
// implement to enable indexing methods
public protocol SpotlightConvertable:SpotlightIndexable {
    var title:String? {get}
    var identifier:String {get}
    
    //optional
    var itemType:String {get}
    var thumbnailImage:UIImage? {get}
    func configureSearchableItem(item:CSSearchableItem)
}