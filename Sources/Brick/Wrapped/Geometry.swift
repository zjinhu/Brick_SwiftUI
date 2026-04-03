import SwiftUI

/// Brick 扩展：几何变化检测
/// Brick extension: Geometry change detection
public extension Brick where Wrapped: View {
    /// 监听几何变化，传递旧值和新值
    /// Listen to geometry changes, pass old and new value
    /// - Parameters:
    ///   - _: 类型参数 / Type parameter
    ///   - transform: 几何转换函数 / Geometry transform function
    ///   - action: 回调闭包，接收旧值和新值 / Callback with old and new value
    @MainActor
    func onGeometryChange<T>(for _: T.Type, of transform: @escaping (GeometryProxy) -> T, action: @escaping (_ oldValue: T, _ newValue: T) -> Void) -> some View where T: Equatable {
        wrapped.modifier(OnGeometryChange(transform: transform, action1: nil, action2: action))
    }
    
    /// 监听几何变化，仅传递新值
    /// Listen to geometry changes, pass new value only
    /// - Parameters:
    ///   - _: 类型参数 / Type parameter
    ///   - transform: 几何转换函数 / Geometry transform function
    ///   - action: 回调闭包，仅接收新值 / Callback with new value only
    @MainActor
    func onGeometryChange<T>(for _: T.Type, of transform: @escaping (GeometryProxy) -> T, action: @escaping (_ newValue: T) -> Void) -> some View where T: Equatable {
        wrapped.modifier(OnGeometryChange(transform: transform, action1: action, action2: nil))
    }
}

/// 几何变化修饰器
/// Geometry change modifier
@MainActor
struct OnGeometryChange<T: Equatable>: ViewModifier {
    @State private var storage: ValueStorage
    
    init(transform: @escaping (GeometryProxy) -> T, action1: ((T) -> Void)?, action2: ((T, T) -> Void)?) {
        storage = ValueStorage(transform: transform, action1: action1, action2: action2)
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .task(id: EquatableProxy(size: proxy.size, safeAreaInsets: proxy.safeAreaInsets)) {
                            storage.setValue(proxy: proxy)
                        }
                }
            )
    }
    
    /// 可等效的代理结构体
    /// Equatable proxy struct
    struct EquatableProxy: Equatable {
        let size: CGSize
        let safeAreaInsets: EdgeInsets
    }
    
    /// 值存储类
    /// Value storage class
    @MainActor
    private class ValueStorage {
        private var oldValue: T?
        private var newValue: T?
        private let transform: (GeometryProxy) -> T
        private let action1: ((T) -> Void)?
        private let action2: ((T, T) -> Void)?
        
        init(transform: @escaping (GeometryProxy) -> T, action1: ((T) -> Void)?, action2: ((T, T) -> Void)?) {
            self.transform = transform
            self.action1 = action1
            self.action2 = action2
        }
        
        /// 设置值并触发回调
        /// Set value and trigger callback
        func setValue(proxy: GeometryProxy) {
            let value = transform(proxy)
            if oldValue == nil {
                oldValue = value
                newValue = value
            } else {
                oldValue = newValue
                newValue = value
            }
            if let action1, let newValue = newValue {
                action1(newValue)
            }
            if let action2, let oldValue, let newValue {
                action2(oldValue, newValue)
            }
        }
    }
}

/// Brick 扩展：视觉特效
/// Brick extension: Visual effect
public extension Brick where Wrapped: View {
    /// 添加基于几何的视觉特效
    /// Add geometry-based visual effect
    /// - Parameter effect: 特效闭包 / Effect closure
    /// - Returns: 修改后的 View / Modified View
    @MainActor func visualEffect(@ViewBuilder _ effect: @escaping @Sendable (AnyView, GeometryProxy) -> some View) -> some View {
        wrapped.modifier(VisualEffect(effect: effect))
    }
}

/// 视觉特效修饰器
/// Visual effect modifier
public struct VisualEffect<Output: View>: ViewModifier {
    private let effect: (AnyView, GeometryProxy) -> Output
    public init(effect: @escaping (AnyView, GeometryProxy) -> Output) {
        self.effect = effect
    }
    
    public func body(content: Content) -> some View {
        content
            .modifier(GeometryProxyWrapper())
            .hidden()
            .overlayPreferenceValue(ProxyKey.self) { proxy in
                if let proxy {
                    effect(AnyView(content), proxy)
                }
            }
    }
}

/// 几何代理包装器
/// Geometry proxy wrapper
struct GeometryProxyWrapper: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: ProxyKey.self, value: proxy)
                }
            )
    }
}

/// 代理偏好键
/// Proxy preference key
struct ProxyKey: @preconcurrency PreferenceKey {
    @MainActor static var defaultValue: GeometryProxy?
    static func reduce(value: inout GeometryProxy?, nextValue: () -> GeometryProxy?) {
        value = nextValue()
    }
}
 
