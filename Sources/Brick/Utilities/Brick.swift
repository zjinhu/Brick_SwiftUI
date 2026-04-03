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

/// Brick 核心包装类型 / Core wrapper type
/// 参考 Kingfisher 的设计模式，用于为 View、AnyTransition、NSObject 等类型提供扩展能力
public let BR = Brick<Any>.self

/// 参考属性包裹 Kingfisher.
/// A wrapper type that provides extension capabilities to various types.
/// Used to enable the `view.ss.xxx` syntax for adding functionality to Views, transitions, etc.
/// 
/// 泛型包装类型，为 Wrapped 类型提供扩展能力
/// Generic wrapper type providing extension capabilities to the wrapped type
public struct Brick<Wrapped> {
    /// 被包装的类型 / The wrapped value
    public let wrapped: Wrapped
    public init(_ wrapped: Wrapped) {
        self.wrapped = wrapped
    }
}

/// View 扩展，通过 ss 属性访问 Brick 功能
/// View extension to access Brick functionality via ss property
public extension View {
    /// 获取 Brick 包装器 / Get Brick wrapper
    var ss: Brick<Self> { .init(self) }
}

/// AnyTransition 扩展，添加 ss 属性
/// AnyTransition extension to add ss property
public extension AnyTransition {
    /// Wraps an `AnyTransition` that can be extended to provide Brick functionality.
    static var ss: Brick<AnyTransition>{
        Brick(.identity)
    }
}

/// Brick 初始化扩展 for Any type
/// Brick init extension for Any type
public extension Brick where Wrapped == Any {
    init(_ content: Wrapped) {
        self.wrapped = content
    }
}

/// NSObjectProtocol 扩展，添加 ss 属性
/// NSObjectProtocol extension to add ss property
public extension NSObjectProtocol {
    /// Wraps an `NSObject` that can be extended to provide Brick functionality.
    var ss: Brick<Self> { .init(self) }
}
