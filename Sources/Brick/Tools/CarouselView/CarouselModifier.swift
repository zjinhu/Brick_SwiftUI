//
//  Modifier.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//

import SwiftUI
import Combine
#if os(macOS)
import AppKit
typealias Application = NSApplication
#else
import UIKit
typealias Application = UIApplication
#endif

public typealias TimePublisher = Publishers.Autoconnect<Timer.TimerPublisher>

public struct AppLifeCycleModifier: ViewModifier {
    
    let active = NotificationCenter.default.publisher(for: Application.didBecomeActiveNotification)
    let inactive = NotificationCenter.default.publisher(for: Application.willResignActiveNotification)
    
    private let action: (Bool) -> ()
    
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
    public func onReceiveAppLifeCycle(perform action: @escaping (Bool) -> ()) -> some View {
        modifier(AppLifeCycleModifier(action))
    }
}

extension View {
    
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

