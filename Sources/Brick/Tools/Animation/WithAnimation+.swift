//
//  WithAnimation.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
 
@available(iOS, deprecated: 17.0)
@available(macOS, deprecated: 14.0)
@available(tvOS, deprecated: 17.0)
@available(watchOS, deprecated: 10.0)
@inline(__always)
@_disfavoredOverload
/// 动画执行完成回调
/// - Parameters:
///   - animation: 动画
///   - delay: 延迟回调时间,应与动画执行时长一致即可
///   - body:
///   - completion: 结束回调
@MainActor
public func withAnimation<Result>(_ animation: Animation = .default,
                                  after delay: TimeInterval = 0,
                                  body: () throws -> Result,
                                  completion: @escaping () -> Void) rethrows -> Result {
    try withTransaction(Transaction(animation: animation),
                        after: delay,
                        body: body,
                        completion: completion)
}

@available(iOS, deprecated: 17.0)
@available(macOS, deprecated: 14.0)
@available(tvOS, deprecated: 17.0)
@available(watchOS, deprecated: 10.0)
@inline(__always)
@_disfavoredOverload
@MainActor
public func withTransaction<Result>(_ transaction: Transaction,
                                    after delay: TimeInterval = 0,
                                    body: () throws -> Result,
                                    completion: @escaping () -> Void) rethrows -> Result {
    defer {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withCATransaction(completion)
        }
    }
    return try withTransaction(transaction, body)
}

@available(iOS, deprecated: 17.0)
@available(macOS, deprecated: 14.0)
@available(tvOS, deprecated: 17.0)
@available(watchOS, deprecated: 10.0)
@inline(__always)
public func withCATransaction(_ completion: @escaping () -> Void) {
    CATransaction.begin()
    CATransaction.setCompletionBlock(completion)
    CATransaction.commit()
}
 
extension Transaction {
    public var isAnimated: Bool {
        let isAnimated = animation != nil
        return isAnimated
    }
}

extension Optional where Wrapped == Transaction {
    public var isAnimated: Bool {
        switch self {
        case .none:
            return false
        case .some(let transation):
            return transation.isAnimated
        }
    }
}

/// 动画执行延迟
/// - Parameters:
///   - animation: 动画
///   - delay: 延迟
///   - body:
@MainActor
public func withAnimation( _ animation: Animation? = .default,
                           after delay: TimeInterval?,
                           body: @escaping () -> Void) {
    if let delay = delay {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(animation) {
                body()
            }
        }
    } else {
        withAnimation(animation) {
            body()
        }
    }
}
@MainActor var _areAnimationsDisabledGlobally: Bool = false

func _withoutAnimation<T>(_ flag: Bool = true, _ body: () -> T) -> T {
    guard flag else {
        return body()
    }

    var transaction = Transaction(animation: .none)

    transaction.disablesAnimations = true

    return withTransaction(transaction) {
        body()
    }
}
@MainActor
func _withoutAppKitOrUIKitAnimation(_ flag: Bool = true, _ body: () -> ()) {
    guard flag else {
        return body()
    }
    
    #if os(iOS)
    UIView.performWithoutAnimation {
        body()
    }
    #else
    body()
    #endif
}
/// Returns the result of recomputing the view’s body with animations disabled.
@MainActor
func withoutAnimation(_ flag: Bool = true, _ body: () -> ()) {
    guard flag else {
        return body()
    }
    
    _areAnimationsDisabledGlobally = true
    
    _withoutAnimation {
        body()
    }
    
    _areAnimationsDisabledGlobally = false
}
