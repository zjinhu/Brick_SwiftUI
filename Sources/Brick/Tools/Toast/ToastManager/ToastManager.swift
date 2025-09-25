//
//  ToastManager.swift
//  Toast
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI
#if !os(visionOS)
public extension View {
    ///添加Toast
    func addToast(_ ob: ToastManager) -> some View {
        self.addToast(
            isActive: ob.isActiveBinding,
            padding: ob.padding,
            position: ob.position,
            content: { ob.content }
        )
    }
}

extension ToastManager {
    //展示自定义View//自己可以重写替换
    public func showText(_ text: String){
        show {
            MessageView(text: text)
        }
    }
}

@MainActor
public class ToastManager: ObservableObject {
    
    public init(position: ToastPosition = .bottom) {
        self.position = position
    }
    
    
    ///Toast停留时长
    public var duration: TimeInterval = 3
    ///Toast显示位置
    public var position: ToastPosition
    ///Toast距离屏幕边缘
    public var padding: CGFloat = 10
 
    typealias Action = @MainActor @Sendable () -> Void

    private var presentationId = UUID()
    
    @Published var content = AnyView(EmptyView())
    
    @Published var isActive = false

    var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }

}

extension ToastManager {
    ///隐藏Toast
    func dismiss() {
        dismiss { @MainActor in }
    }
    ///隐藏Toast,有回调
    func dismiss(completion: @escaping @MainActor @Sendable () -> Void) {
        guard isActive else { 
            Task { @MainActor in completion() }
            return
        }
        isActive = false
        perform(after: 0.3, action: completion)
    }
    ///展示toa,自动隐藏
    public func show<Content: View>(_ content: Content) {
        dismiss { @MainActor in
            self.showAfterDismiss(content: content)
        }
    }
    ///展示toa,手动隐藏
    public func show<Content: View>(@ViewBuilder _ content: @escaping () -> Content) {
        show(content())
    }
}

public enum ToastPosition {
    
    case top, bottom
    
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

private extension ToastManager {

    func perform(_ action: @escaping @MainActor @Sendable () -> Void,
                 after seconds: TimeInterval) {
        Task { @MainActor in
            if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                try? await Task.sleep(for: .seconds(seconds))
            } else {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            }
            action()
        }
    }
    
    func perform(after seconds: TimeInterval,
                 action: @escaping @MainActor @Sendable () -> Void) {
        perform(action, after: seconds)
    }
    
    func showAfterDismiss<Content: View>(content: Content) {
        let id = UUID()
        self.presentationId = id

        self.content = AnyView(content)
        perform(setActive, after: 0.1)
        perform(after: self.duration) { @MainActor in
            guard id == self.presentationId else { return }
            self.dismiss()
        }
    }
    
    func setActive() {
        isActive = true
    }
}

extension View {

    private func addToast<Content: View>(isActive: Binding<Bool>,
                                 padding: CGFloat = 10,
                                 position: ToastPosition = .bottom,
                                 content: @escaping () -> Content) -> some View {
        
        ZStack(alignment: position.alignment) {
            self
            if position == .top{
                ToastView(
                    isActive: isActive,
                    padding: padding,
                    defaultOffset: -500,
                    content: { _ in content() }
                )
            }else{
                ToastView(
                    isActive: isActive,
                    padding: padding,
                    defaultOffset: 500, 
                    content: { _ in content() }
                )
            }

        }
    }
 
}
#endif
