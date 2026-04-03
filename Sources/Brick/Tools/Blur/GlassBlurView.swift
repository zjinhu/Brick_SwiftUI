//
//  GlassBlurView.swift
//  毛玻璃视图/Glass blur view
//
//  Created by iOS on 2024/8/23.
//

import SwiftUI
#if os(iOS)

/// 玻璃模糊效果视图 (iOS 15+)/Glass blur effect view (iOS 15+)
/// 提供类似 iOS 毛玻璃的模糊效果/Provides blur effect similar to iOS glass blur
public struct GlassBlurView: UIViewRepresentable {
    /// 是否移除所有滤镜/Whether to remove all filters
    public var removeAllFilters: Bool = false
    
    /// 初始化玻璃模糊视图/Initialize glass blur view
    /// - Parameter removeAllFilters: 是否移除所有滤镜，仅保留高斯模糊/Whether to remove all filters, keeping only gaussian blur
    public init(removeAllFilters: Bool) {
        self.removeAllFilters = removeAllFilters
    }
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        GlassBlur(removeAllFilters: removeAllFilters)
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}
 
/// 玻璃模糊内部实现/Glass blur internal implementation
class GlassBlur: UIVisualEffectView {
    /// 初始化/Initialize
    /// - Parameter removeAllFilters: 是否移除所有滤镜/Whether to remove all filters
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
 使用示例/Usage example:
 Rectangle()
     .fill(Color.clear)
     .background{
         GlassBlurView(removeAllFilters: true)
             .blur(radius: 5, opaque: true)
             .background(.black.opacity(0.8))
     }
     .frame(height: 180)
 */

/// 玻璃拟态模糊视图/Glassmorphism blur view
/// 提供磨砂玻璃效果的模糊视图/Provides frosted glass blur effect
public struct GlassmorphismBlurView: UIViewRepresentable {
    public typealias UIViewType = GlassmorphismView
    
    /// 初始化玻璃拟态视图/Initialize glassmorphism view
    public init() { }
    
    public func makeUIView(context: Context) -> GlassmorphismView {
        let glassmorphismView = GlassmorphismView()
        return glassmorphismView
    }
    
    public func updateUIView(_ uiView: GlassmorphismView, context: Context) {
        uiView.setBlurDensity(with: 0.1)
    }
}

/// 玻璃拟态视图内部实现/Glassmorphism view internal implementation
public class GlassmorphismView: UIView {

    /// 动画控制器/Animator
    private let animator = UIViewPropertyAnimator(duration: 0.5, curve: .linear)
    /// 模糊视图/Blur view
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    /// 动画完成值/Animator completion value
    private var animatorCompletionValue: CGFloat = 0.2
    /// 背景视图/Background view
    private let backgroundView = UIView()
    
    public override var backgroundColor: UIColor? {
        get {
            return .clear
        }
        set {}
    }

    /// 初始化/Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialize()
    }
    
    deinit {
        Task { @MainActor [weak self] in
            self?.animator.pauseAnimation()
            self?.animator.stopAnimation(true)
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    /// 设置模糊密度/Set blur density
    /// - Parameter density: 模糊密度 (0-1)/Blur density (0-1)
    func setBlurDensity(with density: CGFloat) {
        self.animatorCompletionValue = (1 - density)
        self.animator.fractionComplete = animatorCompletionValue
    }

    /// 初始化视图/Initialize view
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
