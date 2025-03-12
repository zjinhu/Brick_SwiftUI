//
//  BlurView.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI
import Foundation
#if os(macOS)
import AppKit
public struct BlurView: NSViewRepresentable {
    public typealias NSViewType = NSVisualEffectView
    public init() { }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .hudWindow
        effectView.blendingMode = .withinWindow
        effectView.state = NSVisualEffectView.State.active
        return effectView
    }
    
    public func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = .hudWindow
        nsView.blendingMode = .withinWindow
    }
}
#elseif os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
import UIKit

public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = UIVisualEffectView
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: .systemMaterial)
    }
}

#endif
