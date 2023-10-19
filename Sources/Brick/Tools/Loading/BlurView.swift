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
#elseif !os(xrOS)
import UIKit
public struct BlurView: UIViewRepresentable {
    public typealias UIViewType = GlassmorphismView
    
    public init() { }
    
    public func makeUIView(context: Context) -> GlassmorphismView {
        let glassmorphismView = GlassmorphismView()
        return glassmorphismView
    }
    
    public func updateUIView(_ uiView: GlassmorphismView, context: Context) {
        uiView.setBlurDensity(with: 0.1)
    }
}

public class GlassmorphismView: UIView {

    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var animatorCompletionValue: CGFloat = 0.2
    private let backgroundView = UIView()
    public override var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    deinit {
        animator.pauseAnimation()
        animator.stopAnimation(true)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setBlurDensity(with density: CGFloat) {
        self.animatorCompletionValue = (1 - density)
        self.animator.fractionComplete = animatorCompletionValue
    }

    private func initialize() {

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.insertSubview(blurView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor),
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.heightAnchor.constraint(equalTo: self.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])

        animator.addAnimations {
            self.blurView.effect = nil
        }
        animator.fractionComplete = animatorCompletionValue
    }
 
}
#endif
