//
//  OptionalBinding.swift
//
//  Created by iOS on 2023/6/28.
//
//

import SwiftUI

/**
 使可选绑定与一系列原生 SwiftUI 控件一起使用/This type makes it possible to use optional bindings with a
 range of native SwiftUI controls.

 要将可选绑定传递给任何非可选参数，只需定义一个回退值/To pass in optional bindings to any non-optional parameters,
 just define a fallback value:

 ```swift
 @State
 var myValue: Double?

 func doSomething(with binding: Binding<Double>) { ... }

 doSomething(with: $myValue ?? 0)
 ```
 */
/// 创建可选绑定的回退绑定/Create fallback binding for optional binding
/// - Parameters:
///   - binding: 可选绑定/Optional binding
///   - defaultValue: 默认值/Default value
/// - Returns: 非可选绑定/Non-optional binding
public func OptionalBinding<T: Sendable>(_ binding: Binding<T?>, _ defaultValue: T) -> Binding<T> {
    Binding<T>(get: {
        binding.wrappedValue ?? defaultValue
    }, set: {
        binding.wrappedValue = $0
    })
}

/// 可选绑定的空值合并运算符/Null-coalescing operator for optional binding
/// - Parameters:
///   - left: 可选绑定/Optional binding
///   - right: 默认值/Default value
/// - Returns: 非可选绑定/Non-optional binding
public func ??<T: Sendable> (left: Binding<T?>, right: T) -> Binding<T> {
    OptionalBinding(left, right)
}
