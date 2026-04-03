//
//  LoadingManager.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

/// 添加Loading视图/Add loading view
/// 可在WindowGroup里给ContentView添加/Can add to ContentView in WindowGroup
public extension View {
    /// 添加loading/Add loading
    /// - Parameter manager: LoadingManager实例/LoadingManager instance
    /// - Returns: 添加了loading的视图/View with loading added
    func addLoading(_ manager: LoadingManager ) -> some View {
        self.addLoading(isActive: manager.isActiveBinding, manager: manager, content: { manager.content })
    }
}

/// LoadingManager扩展/LoadingManager extension
extension LoadingManager {
    /// 展示自定义Loading/Show custom loading
    /// 可自行重写替换/Can be overridden
    public func showLoading(){
        show {
            LoadingView()
                .environmentObject(self)
        }
    }
    /// 展示自定义Progress/Show custom progress
    /// 可自行重写替换/Can be overridden
    public func showProgress(){
        show {
            StepView()
                .environmentObject(self)
        }
    }
    /// 展示自定义Success/Show custom success
    /// 可自行重写替换/Can be overridden
    public func showSuccess(){
        show {
            SuccessView()
                .environmentObject(self)
        }
        hideDelay()
    }
    /// 展示自定义Failed/Show custom failed
    /// 可自行重写替换/Can be overridden
    public func showFail(){
        show {
            FailView()
                .environmentObject(self)
        }
        hideDelay()
    }
}

/// Loading管理器/Loading manager
/// 用于管理HUD提示的显示和隐藏。/Manages HUD display and hiding.
@MainActor
public class LoadingManager: ObservableObject {
    /// 初始化Loading管理器/Initialize loading manager
    public init() {}
    
    /// HUD提示文本/HUD text
    @Published public var text: String?
    /// HUD提示字体颜色/HUD text color
    @Published public var textColor = Color.primary
    /// HUD提示字体/HUD text font
    @Published public var textFont: Font = .system(size: 15, weight: .medium)
    /// HUD Loading颜色/HUD loading color
    @Published public var accentColor = Color.primary
    /// 进度条进度 (0-1)/Progress value (0-1)
    @Published public var progress: CGFloat = 0
    /// HUD遮罩颜色/HUD mask color
    @Published public var maskColor: Color? = .clear
    /// 展示的容器/Container to display
    @Published var content = AnyView(EmptyView())
    /// 展示状态/Display state
    @Published var isActive = false
    /// 状态绑定/State binding
    var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }

}

/// LoadingManager方法扩展/LoadingManager methods extension
extension LoadingManager {
    /// 直接关闭loading/Hide loading directly
    public func hide() {
        isActive = false
    }
    /// 展示loading/Show loading
    /// - Parameter content: 要展示的内容视图/Content view to display
    public func show<Content: View>(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = AnyView(content())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isActive = true
        }
    }
  
    /// 延迟隐藏/Hide with delay
    private func hideDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isActive = false
        }
    }
}

/// View扩展/View extension
extension View {
    /// 添加loading内部实现/Add loading internal implementation
    private func addLoading<Content: View>(isActive: Binding<Bool>,
                                           manager: LoadingManager,
                                   content: @escaping () -> Content) -> some View {
        overlay{
            ContainerView(isActive: isActive, manager: manager, content: { _ in content() })
        }
    }

}
