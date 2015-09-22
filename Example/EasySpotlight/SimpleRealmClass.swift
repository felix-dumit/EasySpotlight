//
//  SimpleRealmClass.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 9/22/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import EasySpotlight
import RealmSwift

// Dog model
class SimpleRealmClass: Object {
    dynamic var name = ""
    dynamic var longDescription = ""
    dynamic var id = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(name:String, longDescription:String) {
        self.init()
        self.name = name
        self.longDescription = longDescription
        self.id = name.hashValue
    }
    
}

extension SimpleRealmClass:SpotlightConvertable {
    var title:String? { return name }
    var contentDescription:String? { return longDescription }
    var identifier:String { return "\(id)" }
}

extension SimpleRealmClass:SpotlightRetrievable {
    static func itemWithIdentifier(identifier: String) -> Self? {
        let realm = try! Realm()
        return realm.objectForPrimaryKey(self, key: Int(identifier)!)
    }
}