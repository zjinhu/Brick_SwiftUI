//
//  Modifier.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//

import SwiftUI

#if os(macOS)
import AppKit
typealias Application = NSApplication
#else
import UIKit
typealias Application = UIApplication
#endif

struct AppLifeCycleModifier: ViewModifier {
    
    let active = NotificationCenter.default.publisher(for: Application.didBecomeActiveNotification)
    let inactive = NotificationCenter.default.publisher(for: Application.willResignActiveNotification)
    
    private let action: (Bool) -> ()
    
    init(_ action: @escaping (Bool) -> ()) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
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
    func onReceiveAppLifeCycle(perform action: @escaping (Bool) -> ()) -> some View {
        modifier(AppLifeCycleModifier(action))
    }
}
