//
//  Untitled.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2025.06.19.
//
import SwiftUI

@available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *)
@MainActor
public class NavigatorPath: ObservableObject {
    private var isNavigating = false
    
    @Published public var path = NavigationPath()
    
    public init() { }
}

@available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *)
public extension NavigatorPath {
    func push<T: Hashable>(_ screen: T) {
//        path.append(screen)
        // 防止快速点击
         guard !isNavigating else { return }
         isNavigating = true
        // iOS 16/17 需要延迟
         if #available(iOS 18.0, *) {
             path.append(screen)
             isNavigating = false
         } else {
             Task { @MainActor in
                 try? await Task.sleep(nanoseconds: 100_000_000) // 0.1秒
                 self.path.append(screen)
                 try? await Task.sleep(nanoseconds: 300_000_000) // 0.3秒
                 self.isNavigating = false
             }
         }
    }

    func pop(_ count: Int = 1) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }
    ///返回到栈数组的第几项上,根目录表示清空了数组,数组中没有值了,第一页为0
    func popTo(index: Int) {
        let countToRemove = path.count - (index + 1)
        guard countToRemove > 0 else { return }
        path.removeLast(countToRemove)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

