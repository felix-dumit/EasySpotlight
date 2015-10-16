//
//  MockSearchableIndex.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 10/16/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import CoreSpotlight
@testable import EasySpotlight


extension SimpleStruct:Equatable {}

func ==(lhs: SimpleStruct, rhs: SimpleStruct) -> Bool {
    return lhs.title == rhs.title && lhs.contentDescription == rhs.contentDescription && lhs.identifier == rhs.identifier
}

extension SpotlightConvertable {
    
    var userActivityWhenOpened:NSUserActivity {
        let activity = NSUserActivity(activityType: CSSearchableItemActionType)
        
        activity.userInfo?[CSSearchableItemActivityIdentifier] = self.uniqueIdentifier
        
        return activity
    }
}

class MockSearchableIndex:CSSearchableIndex {
    var indexedItems = [CSSearchableItem]()
    
    override func indexSearchableItems(items: [CSSearchableItem], completionHandler: ((NSError?) -> Void)?) {
        indexedItems.appendContentsOf(items)
        completionHandler?(nil)
    }
    
    override func deleteSearchableItemsWithDomainIdentifiers(domainIdentifiers: [String], completionHandler: ((NSError?) -> Void)?) {
        indexedItems = indexedItems.filter {
            !domainIdentifiers.contains($0.domainIdentifier ?? "")
        }
        completionHandler?(nil)
    }
    
    override func deleteSearchableItemsWithIdentifiers(identifiers: [String], completionHandler: ((NSError?) -> Void)?) {
        indexedItems = indexedItems.filter {
            !identifiers.contains($0.uniqueIdentifier)
        }
        completionHandler?(nil)
    }
    
}