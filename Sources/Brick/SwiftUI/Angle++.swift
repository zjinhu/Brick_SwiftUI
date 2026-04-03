//
//  Angle++.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/28.
//  Angle 扩展 - 提供 Angle 的便捷初始化和运算方法 / Angle extension - provides convenient Angle initialization and calculation methods
//

import SwiftUI

// MARK: - Angle Extension / Angle 扩展

/// Angle 扩展 / Angle extension
extension Angle {
    /// PI 常量 / PI constant
    @inlinable
    public static var pi: Angle {
        return .init(radians: Double.pi)
    }
    
    /// 取余运算 / Remainder calculation
    /// - Parameter other: 除数 / Divisor
    /// - Returns: 余数 / Remainder
    @inlinable
    public func remainder(dividingBy other: Angle) -> Angle   {
        .init(radians: radians.remainder(dividingBy: other.radians))
    }
    
    /// 从 CGFloat 度数初始化 / Initialize from CGFloat degrees
    /// - Parameter degrees: 度数值 / Degrees value
    @inlinable
    public init(degrees: CGFloat) {
        self.init(degrees: Double(degrees))
    }
    
    /// 从 Int 度数初始化 / Initialize from Int degrees
    /// - Parameter degrees: 度数值 / Degrees value
    @inlinable
    public init(degrees: Int) {
        self.init(degrees: Double(degrees))
    }
    
    /// 从 CGFloat 弧度初始化 / Initialize from CGFloat radians
    /// - Parameter radians: 弧度值 / Radians value
    @inlinable
    public init(radians: CGFloat) {
        self.init(radians: Double(radians))
    }
    
    /// 从 Int 弧度初始化 / Initialize from Int radians
    /// - Parameter radians: 弧度值 / Radians value
    @inlinable
    public init(radians: Int) {
        self.init(radians: Double(radians))
    }
    
    /// 从 CGFloat 创建度数 Angle / Create Angle from CGFloat degrees
    /// - Parameter value: 度数值 / Degrees value
    /// - Returns: Angle 实例 / Angle instance
    public static func degrees(_ value: CGFloat) -> Angle {
        return .init(degrees: value)
    }
    
    /// 从 Int 创建度数 Angle / Create Angle from Int degrees
    /// - Parameter value: 度数值 / Degrees value
    /// - Returns: Angle 实例 / Angle instance
    public static func degrees(_ value: Int) -> Angle {
        return .init(degrees: value)
    }
    
    /// 从 CGFloat 创建弧度 Angle / Create Angle from CGFloat radians
    /// - Parameter value: 弧度值 / Radians value
    /// - Returns: Angle 实例 / Angle instance
    public static func radians(_ value: CGFloat) -> Angle {
        return .init(radians: value)
    }
    
    /// 从 Int 创建弧度 Angle / Create Angle from Int radians
    /// - Parameter value: 弧度值 / Radians value
    /// - Returns: Angle 实例 / Angle instance
    public static func radians(_ value: Int) -> Angle {
        return .init(radians: value)
    }
}
