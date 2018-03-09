//
//  SimpleStruct.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 9/10/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import EasySpotlight

struct SimpleStruct: SpotlightConvertable {

    var title: String?
    var contentDescription: String?
    var identifier: String

}

extension SimpleStruct: SpotlightSyncRetrievable {

    static func retrieveItem(with identifier: String) throws -> SimpleStruct? {
        return SimpleStruct(title: "item_\(identifier)", contentDescription: "cool", identifier: identifier)
    }

}

extension SimpleStruct: Equatable {

    static func == (lhs: SimpleStruct, rhs: SimpleStruct) -> Bool {
        return lhs.title == rhs.title &&
            lhs.contentDescription == rhs.contentDescription &&
            lhs.identifier == rhs.identifier
    }
}
