//
//  GenericCallback.swift
//  Pods
//
//  Created by Felix Dumit on 9/22/15.
//
//

import Foundation

//http://stackoverflow.com/questions/29512583/casting-closures-in-swift
internal typealias GenericCallbackType = (_ value: Any?) -> Void

internal final class GenericCallback<T> {

    func executeCallback(_ value: Any?) {
        if let specificValue = value as? T {
            specificCallback( specificValue )
        }
    }

    init(callback:@escaping (_ value: T?) -> Void ) {
        self.specificCallback = callback
    }

    fileprivate let specificCallback:(_ value: T?) -> Void
}
