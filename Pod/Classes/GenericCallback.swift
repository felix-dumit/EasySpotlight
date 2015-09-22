//
//  GenericCallback.swift
//  Pods
//
//  Created by Felix Dumit on 9/22/15.
//
//

import Foundation

//http://stackoverflow.com/questions/29512583/casting-closures-in-swift
internal typealias GenericCallbackType = (value: Any?) -> Void

internal final class GenericCallback<T> {
    
    func executeCallback(value: Any?) -> Void {
        if let specificValue = value as? T {
            specificCallback( value: specificValue )
        }
    }
    
    init(callback:(value: T?)->Void ) {
        self.specificCallback = callback
    }
    
    private let specificCallback:(value: T?)->Void
}