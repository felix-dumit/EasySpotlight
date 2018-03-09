//
//  Utils.swift
//  EasySpotlight
//
//  Created by Felix Dumit on 3/8/18.
//

import Foundation

struct IdentifierGenerator {
    internal static let separator = "|__|"

    internal static func combineIntoUniqueIdentifier(_ identifier: String, domain: String) -> String {
        return "\(domain)\(separator)\(identifier)"
    }

    internal static func decombineFromUniqueIdentifier(_ combined: String) -> (domain: String, identifier: String) {
        let comps = combined.components(separatedBy: separator)
        return (comps[0], comps[1])
    }
}
