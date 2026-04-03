//
//  Modifier.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//  走马灯修饰器/Carousel modifiers
//  提供应用生命周期和定时器接收的View修饰器/Provides View modifiers for app lifecycle and timer reception

import SwiftUI
import Combine
#if os(macOS)
import AppKit
typealias Application = NSApplication
#else
import UIKit
typealias Application = UIApplication
#endif

/// 时间发布者类型别名/Time publisher type alias
public typealias TimePublisher = Publishers.Autoconnect<Timer.TimerPublisher>

/// 应用生命周期修饰器/App lifecycle modifier
/// 监听应用进入前台和进入后台/Monitors app entering foreground and background
public struct AppLifeCycleModifier: ViewModifier {
    
    let active = NotificationCenter.default.publisher(for: Application.didBecomeActiveNotification)
    let inactive = NotificationCenter.default.publisher(for: Application.willResignActiveNotification)
    
    private let action: (Bool) -> ()
    
    /// 创建应用生命周期修饰器/Creates an app lifecycle modifier
    /// - Parameter action: 应用状态变更回调，true表示进入前台，false表示进入后台/App state change callback, true for foreground, false for background
    public init(_ action: @escaping (Bool) -> ()) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content
            .onAppear() 
            .onReceive(active){ _ in
                action(true)
            }
            .onReceive(inactive){ _ in
                action(false)
            }
    }
}

extension View {
    /// 监听应用生命周期变化/Monitors app lifecycle changes
    /// - Parameter action: 回调闭包，true表示进入前台，false表示进入后台/Callback closure, true for foreground, false for background
    /// - Returns: 应用了生命周期监听的视图/View with lifecycle monitoring applied
    public func onReceiveAppLifeCycle(perform action: @escaping (Bool) -> ()) -> some View {
        modifier(AppLifeCycleModifier(action))
    }
}

extension View {
    /// 条件性接收定时器消息/Conditionally receives timer messages
    /// - Parameters:
    ///   - timer: 定时器发布者，可为nil/Timer publisher, can be nil
    ///   - action: 定时器触发时的回调/Callback when timer fires
    /// - Returns: 应用了定时器接收的视图/View with timer reception applied
    public func onReceive(timer: TimePublisher?,
                   perform action: @escaping (Timer.TimerPublisher.Output) -> Void) -> some View {
        Group {
            if let timer = timer {
                onReceive(timer){ value in
                    action(value)
                }
            } else {
                self
            }
        }
    }
}

