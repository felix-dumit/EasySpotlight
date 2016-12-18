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
    dynamic var identifier = ""
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
    
    required convenience init(name:String, longDescription:String) {
        self.init()
        self.name = name
        self.longDescription = longDescription
        self.identifier = name.hashValue.description
    }
    
}

extension SimpleRealmClass:SpotlightConvertable {
    /// unique idenfitier

    var title:String? { return name }
    var contentDescription:String? { return longDescription }
}

extension SimpleRealmClass:SpotlightRetrievable {
    static func item(with identifier: String) -> Self? {
        let realm = try! Realm()
        return realm.object(ofType: self, forPrimaryKey: identifier as AnyObject)
    }
}
