//
//  SimpleStruct.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 9/10/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Foundation
import EasySpotlight

struct SimpleStruct:SpotlightConvertable {
    var title:String? = nil
    var contentDescription:String? = nil
    var identifier:String
}

extension SimpleStruct:SpotlightRetrievable {

    static func itemWithIdentifier(identifier: String) -> SimpleStruct? {
        //query your DB or network
        return SimpleStruct(title: "item_\(identifier)", contentDescription: "cool", identifier: identifier)
    }

}