//
//  NavigatorPath.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2025.06.19.
//
import SwiftUI
@available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *)
public class NavigatorPath: ObservableObject {
    
    @Published public var path = NavigationPath()
    
    public init() { }
}

/// 为系统的 NavigationPath 提供便捷的导航方法
@available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *)
public extension NavigationPath {
    /// 推入一个新页面到导航栈
    /// - Parameter value: 任何遵循 Hashable 的值
    mutating func push<T: Hashable>(_ value: T) {
        self.append(value)
    }
    
    /// 从导航栈中弹出指定数量的页面
    /// - Parameter count: 要弹出的页面数量，默认为 1
    mutating func pop(_ count: Int = 1) {
        guard self.count >= count else { return }
        self.removeLast(count)
    }
    
    /// 返回到指定索引位置的页面
    /// - Parameter index: 目标页面的索引（0 表示根视图）
    mutating func popTo(index: Int) {
        let countToRemove = self.count - (index + 1)
        guard countToRemove > 0 else { return }
        self.removeLast(countToRemove)
    }
    
    /// 返回到根视图（清空整个导航栈）
    mutating func popToRoot() {
        self.removeLast(self.count)
    }
}
