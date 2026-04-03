//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  加载视图组件/Loading view component
//  显示带动画的加载遮罩/Show loading overlay with animation
import SwiftUI
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
/// 加载视图扩展/Loading view extension
public extension View {
    /// 显示加载遮罩/Show loading overlay
    /// - Parameters:
    ///   - isPresented: 显示状态绑定/Display state binding
    ///   - options: 加载选项/Loading options
    ///   - onDismiss: 关闭回调/Dismiss callback
    ///   - content: 加载内容视图/Loading content view
    /// - Returns: 应用了加载视图的视图/View with loading applied
    func loading<LoadingContent: View>(
        isPresented: Binding<Bool>, 
        options: LoadingOptions = .init(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> LoadingContent) -> some View {
        self.modifier(
            CustomLoading(showLoading: isPresented, options: options, onDismiss: onDismiss, content: content)
        )
    }

}

/// 自定义加载修饰器/Custom loading modifier
struct CustomLoading<LoadingContent: View>: ViewModifier {
    @Binding var showLoading: Bool

    let options: LoadingOptions
    let onDismiss: (() -> Void)?

    @State private var workItem: DispatchWorkItem?

    private let loadingInnerContent: LoadingContent

    @ViewBuilder
    private var loadingRenderContent: some View {
        if showLoading {
            Group {
                switch options.modifierType {
                case .scale:
                    loadingInnerContent
                        .modifier(LoadingScale(showLoading: $showLoading, options: options))
                default:
                    loadingInnerContent
                        .modifier(LoadingFade(showLoading: $showLoading, options: options))
                }
            }
            .onTapGesture(perform: dismissOnTap)
        }
    }

    init(
        showLoading: Binding<Bool>,
        options: LoadingOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> LoadingContent
    ) {
        self._showLoading = showLoading
        self.options = options
        self.onDismiss = onDismiss
        self.loadingInnerContent = content()
    }

    func body(content: Content) -> some View {

        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                Group { EmptyView() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(options.backdrop?.ignoresSafeArea())
                    .opacity(options.backdrop != nil && showLoading ? 1 : 0)
                    .onTapGesture(perform: dismissOnTap)
            )
            .overlay(alignment: .center){
                loadingRenderContent
            }
            .ss.onChange(of: showLoading) { newValue in
                if newValue{
                    dismissAfterTimeout()
                }
            }
    }

    private func dismissAfterTimeout() {
        guard workItem == nil else {
            return
        }
        if let timeout = options.hideAfter, showLoading, options.hideAfter != nil {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismiss()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: task)
        }
    }

    private func dismiss() {
        withAnimation(options.animation) {
            showLoading = false
            workItem = nil
            onDismiss?()
        }
    }

    private func dismissOnTap() {
        if(options.dismissOnTap ?? true){
            self.dismiss()
        }
    }
}

/// 自定义加载修饰器协议/Custom loading modifier protocol
protocol CustomLoadingModifier: ViewModifier {
    var showLoading: Bool { get set }
    var options: LoadingOptions? { get }
}

/// 加载选项/Loading options
public struct LoadingOptions {
    /// 自动隐藏时间/Auto hide timeout
    public var hideAfter: TimeInterval?
    
    /// 背景遮罩颜色/Backdrop color
    public var backdrop: Color?
    
    /// 动画/Animation
    public var animation: Animation?
    
    /// 修饰器类型/Modifier type
    public var modifierType: ModifierType
    
    /// 点击是否关闭/Whether dismiss on tap
    public var dismissOnTap: Bool? = false

    /// 修饰器类型枚举/Modifier type enum
    public enum ModifierType {
        case fade, scale
    }

    /// 初始化加载选项/Initialize loading options
    /// - Parameters:
    ///   - hideAfter: 自动隐藏时间/Auto hide timeout
    ///   - backdrop: 背景遮罩颜色/Backdrop color
    ///   - animation: 动画/Animation
    ///   - modifierType: 修饰器类型/Modifier type
    ///   - dismissOnTap: 点击是否关闭/Whether dismiss on tap
    public init(
        hideAfter: TimeInterval? = nil,
        backdrop: Color? = nil,
        animation: Animation = .linear,
        modifierType: ModifierType = .fade,
        dismissOnTap: Bool? = false
    ) {
        self.hideAfter = hideAfter
        self.backdrop = backdrop
        self.animation = animation
        self.modifierType = modifierType
        self.dismissOnTap = dismissOnTap
    }
}

/// 淡入淡出加载效果/Fade loading effect
struct LoadingFade: CustomLoadingModifier {
    @Binding var showLoading: Bool
    let options: LoadingOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(options?.animation ?? .linear))
            .opacity(showLoading ? 1 : 0)
            .zIndex(1)
    }
}

/// 缩放加载效果/Scale loading effect
struct LoadingScale: CustomLoadingModifier {
    @Binding var showLoading: Bool
    let options: LoadingOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.scale.animation(options?.animation ?? .linear))
            .opacity(showLoading ? 1 : 0)
            .zIndex(1)
    }
}
#endif 
