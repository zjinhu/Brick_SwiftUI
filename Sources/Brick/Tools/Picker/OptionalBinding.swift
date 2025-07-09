//
//  OptionalBinding.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 This type makes it possible to use optional bindings with a
 range of native SwiftUI controls.

 To pass in optional bindings to any non-optional parameters,
 just define a fallback value:

 ```swift
 @State
 var myValue: Double?

 func doSomething(with binding: Binding<Double>) { ... }

 doSomething(with: $myValue ?? 0)
 ```
 */
public func OptionalBinding<T: Sendable>(_ binding: Binding<T?>, _ defaultValue: T) -> Binding<T> {
    Binding<T>(get: {
        binding.wrappedValue ?? defaultValue
    }, set: {
        binding.wrappedValue = $0
    })
}

public func ??<T: Sendable> (left: Binding<T?>, right: T) -> Binding<T> {
    OptionalBinding(left, right)
}
