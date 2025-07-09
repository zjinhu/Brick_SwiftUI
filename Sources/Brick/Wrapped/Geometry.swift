import SwiftUI

public extension Brick where Wrapped: View {
    @MainActor
    func onGeometryChange<T>(for _: T.Type, of transform: @escaping (GeometryProxy) -> T, action: @escaping (_ oldValue: T, _ newValue: T) -> Void) -> some View where T: Equatable {
        wrapped.modifier(OnGeometryChange(transform: transform, action1: nil, action2: action))
    }
    
    @MainActor
    func onGeometryChange<T>(for _: T.Type, of transform: @escaping (GeometryProxy) -> T, action: @escaping (_ newValue: T) -> Void) -> some View where T: Equatable {
        wrapped.modifier(OnGeometryChange(transform: transform, action1: action, action2: nil))
    }
}

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
    
    struct EquatableProxy: Equatable {
        let size: CGSize
        let safeAreaInsets: EdgeInsets
    }
    
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

public extension Brick where Wrapped: View {

    @MainActor func visualEffect(@ViewBuilder _ effect: @escaping @Sendable (AnyView, GeometryProxy) -> some View) -> some View {
        wrapped.modifier(VisualEffect(effect: effect))
    }
}

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

struct ProxyKey: @preconcurrency PreferenceKey {
    @MainActor static var defaultValue: GeometryProxy?
    static func reduce(value: inout GeometryProxy?, nextValue: () -> GeometryProxy?) {
        value = nextValue()
    }
}
 
