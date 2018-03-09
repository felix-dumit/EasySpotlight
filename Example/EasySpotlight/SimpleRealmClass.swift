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
final class SimpleRealmClass: Object {
    @objc dynamic var name = ""
    @objc dynamic var longDescription = ""
    @objc dynamic var identifier = ""

    override static func primaryKey() -> String? {
        return "identifier"
    }

    required convenience init(name: String, longDescription: String) {
        self.init()
        self.name = name
        self.longDescription = longDescription
        self.identifier = name.hashValue.description
    }

}

extension SimpleRealmClass: SpotlightConvertable {
    /// unique idenfitier
    var title: String? { return name }
    var contentDescription: String? { return longDescription }
}

extension SimpleRealmClass: SpotlightRetrievable {

    static func retrieveItem(with identifier: String) throws -> (() throws -> SimpleRealmClass?) {
        let obj = try Realm().object(ofType: self, forPrimaryKey: identifier)
        let safe = obj.map { ThreadSafeReference(to: $0) }
        return {
            guard let safe = safe else { return nil }
            return try Realm().resolve(safe)
        }
    }
}
