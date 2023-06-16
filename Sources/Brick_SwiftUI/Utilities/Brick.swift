//
//  SwiftBrick.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/30.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import SwiftUI
// MARK: ===================================VC基类:协议=========================================

public let BR = Brick<Any>.self

/// 参考属性包裹 Kingfisher.
public struct Brick<Wrapped> {
    public let wrapped: Wrapped
    public init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
}
 
public extension View {
    var ss: Brick<Self> { .init(self) }
}
 
public extension AnyTransition {
    /// Wraps an `AnyTransition` that can be extended to provide Brick functionality.
    static var ss: Brick<AnyTransition>{
        Brick(.identity)
    }
}

public extension Brick where Wrapped == Any {
    init(_ content: Wrapped) {
        self.wrapped = content
    }
}

public extension NSObjectProtocol {
    /// Wraps an `NSObject` that can be extended to provide Brick functionality.
    var ss: Brick<Self> { .init(self) }
}
