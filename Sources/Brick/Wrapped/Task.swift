//
//  TaskEx.swift
//  SwiftBrick
//
//  回退的 .task 修饰器 for iOS 14-
//  Backported .task modifier for iOS 14-
//  添加异步任务，支持基于 id 取消
//  Add async task with id-based cancellation
//
//  Created by iOS on 2023/5/23.
//

import SwiftUI
import Combine

/// 已废弃 iOS 15+ 推荐使用原生 .task
/// Deprecated iOS 15+, use native .task
@available(iOS, deprecated: 15.0)
@available(macOS, deprecated: 12.0)
@available(tvOS, deprecated: 15.0)
@available(watchOS, deprecated: 8.0)

/// Brick 扩展：添加异步任务
/// Brick extension: Add async task
public extension Brick where Wrapped: View {
    
    /// Adds an asynchronous task to perform when this view appears.
    ///
    /// Use this modifier to perform an asynchronous task with a lifetime that
    /// matches that of the modified view. If the task doesn't finish
    /// before SwiftUI removes the view or the view changes identity, SwiftUI
    /// cancels the task.
    ///
    /// - Parameters:
    ///   - priority: The task priority to use when creating the asynchronous
    ///     task. The default priority is `.userInitiated`
    ///   - action: A closure that SwiftUI calls as an asynchronous task
    ///     when the view appears.
    ///
    /// - Returns: A view that runs the specified action asynchronously.
    @MainActor @ViewBuilder
    func task(priority: TaskPriority = .userInitiated, @_inheritActorContext _ action: @escaping @Sendable () async -> Void) -> some View {
        wrapped.modifier(
            TaskModifier(
                id: 0,
                priority: priority,
                action: action
            )
        )
    }
    
    /// Adds a task to perform when this view appears or when a specified
    /// value changes.
    ///
    /// This method behaves like ``View/task(priority:_:)``, except that it also
    /// cancels and recreates the task when a specified value changes.
    ///
    /// - Parameters:
    ///   - id: The value to observe for changes.
    ///   - priority: The task priority.
    ///   - action: A closure that SwiftUI calls as an asynchronous task.
    ///
    /// - Returns: A view that runs the specified action asynchronously.
    @MainActor @ViewBuilder
    func task<T: Equatable>(id: T, priority: TaskPriority = .userInitiated, @_inheritActorContext _ action: @escaping @Sendable () async -> Void) -> some View {
        wrapped.modifier(
            TaskModifier(
                id: id,
                priority: priority,
                action: action
            )
        )
    }
    
}

/// 任务修饰器 (iOS 14-)
/// Task modifier (iOS 14-)
private struct TaskModifier<ID: Equatable>: ViewModifier {
    
    var id: ID
    var priority: TaskPriority
    var action: @Sendable () async -> Void
    
    @State private var task: Task<Void, Never>?
    @State private var publisher = PassthroughSubject<(), Never>()
    
    init(id: ID, priority: TaskPriority, action: @escaping @Sendable () async -> Void) {
        self.id = id
        self.priority = priority
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .ss.onChange(of: id) {
                publisher.send()
            }
            .onReceive(publisher) { _ in
                task?.cancel()
                task = Task(priority: priority, operation: action)
            }
            .onAppear {
                task?.cancel()
                task = Task(priority: priority, operation: action)
            }
            .onDisappear {
                task?.cancel()
                task = nil
            }
    }
    
}

/// Adds a task to perform when this view appears or when a specified
/// value changes.
///
/// This method behaves like ``View/task(priority:_:)``, except that it also
/// cancels and recreates the task when a specified value changes. To detect
/// a change, the modifier tests whether a new value for the `id` parameter
/// equals the previous value. For this to work,
/// the value's type must conform to the `Equatable` protocol.
///
/// For example, if you define an equatable `Server` type that posts custom
/// notifications whenever its state changes --- for example, from _signed
/// out_ to _signed in_ --- you can use the task modifier to update
/// the contents of a ``Text`` view to reflect the state of the
/// currently selected server:
///
///     Text(status ?? "Signed Out")
///         .task(id: server) {
///             let sequence = NotificationCenter.default.notifications(
///                 named: .didChangeStatus,
///                 object: server)
///             for try await notification in sequence {
///                 status = notification.userInfo["status"] as? String
///             }
///         }
///
/// Elsewhere, the server defines a custom `didUpdateStatus` notification:
///
///     extension NSNotification.Name {
///         static var didUpdateStatus: NSNotification.Name {
///             NSNotification.Name("didUpdateStatus")
///         }
///     }
///
/// The server then posts a notification of this type whenever its status
/// changes, like after the user signs in:
///
///     let notification = Notification(
///         name: .didUpdateStatus,
///         object: self,
///         userInfo: ["status": "Signed In"])
///     NotificationCenter.default.post(notification)
///
/// The task attached to the ``Text`` view gets and displays the status
/// value from the notification's user information dictionary. When the user
/// chooses a different server, SwiftUI cancels the task and creates a new
/// one, which then starts waiting for notifications from the new server.
///
/// - Parameters:
///   - id: The value to observe for changes. The value must conform
///     to the `Equatable` protocol.
///   - priority: The task priority to use when creating the asynchronous
///     task. The default priority is `.userInitiated`
///   - action: A closure that SwiftUI calls as an asynchronous task
///     when the view appears. SwiftUI automatically cancels the task
///     if the view disappears before the action completes. If the
///     `id` value changes, SwiftUI cancels and restarts the task.
///
/// - Returns: A view that runs the specified action asynchronously when
///   the view appears, or restarts the task with the `id` value changes.

//extension View {
//    @_disfavoredOverload
//    public func task(priority: TaskPriority = .userInitiated, _ action: @escaping @Sendable () async -> Void) -> some View {
//        self.modifier(TaskModifier(id: 0, priority: priority, action: action))
//    }
//}
