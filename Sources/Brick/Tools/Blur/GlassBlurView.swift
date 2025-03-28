//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2024/8/23.
//

import SwiftUI
#if os(iOS)
public struct GlassBlurView: UIViewRepresentable {
    public var removeAllFilters: Bool = false
    
    public init(removeAllFilters: Bool) {
        self.removeAllFilters = removeAllFilters
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        GlassBlur(removeAllFilters: removeAllFilters)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}
 
class GlassBlur: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0
        }
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur"
                })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/***
 Rectangle()
     .fill(Color.clear)
     .background{
         GlassBlurView(removeAllFilters: true)
             .blur(radius: 5, opaque: true)
             .background(.black.opacity(0.8))
     }
     .frame(height: 180)
 */

public struct GlassmorphismBlurView: UIViewRepresentable {
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
