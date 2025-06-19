//
//  Untitled.swift
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

@available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *)
public extension NavigatorPath {
    func push<T: Hashable>(_ screen: T) {
        path.append(screen)
    }

    func pop(_ count: Int = 1) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }

    func popTo(index: Int) {
        let countToRemove = path.count - (index + 1)
        guard countToRemove > 0 else { return }
        path.removeLast(countToRemove)
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}

