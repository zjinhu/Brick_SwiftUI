//
//  LoadingManager.swift
//  Toast
//
//  Created by iOS on 2023/4/27.
//

import SwiftUI

public extension View {
    ///添加loading,也可以WindowGroup里给ContentView添加
    func addLoading(_ ob: LoadingManager ) -> some View {
        self.addLoading(isActive: ob.isActiveBinding, content: { ob.content })
    }
}

extension LoadingManager {
    //展示自定义Loading//自己可以重写替换
    public func showLoading(){
        show {
            LoadingView()
        }
    }
    //展示自定义Progress//自己可以重写替换
    public func showProgress(){
        show {
            StepView()
        }
    }
    //展示自定义Success//自己可以重写替换
    public func showSuccess(){
        show {
            SuccessView()
        }
        dismissDelay()
    }
    //展示自定义Failed//自己可以重写替换
    public func showFail(){
        show {
            FailView()
        }
        dismissDelay()
    }
}

public class LoadingManager: ObservableObject {
    public init() {}
    //HUD提示
    @Published public var text: String?
    //HUD提示字体颜色
    @Published public var textColor = Color.black
    //HUD提示字体颜色
    @Published public var textFont: Font = .system(size: 15, weight: .medium)
    //HUD Loading颜色
    @Published public var accentColor = Color.blue
    ///进度条进度 0--1
    @Published public var progress: CGFloat = 0
    
    
    ///展示的容器
    @Published var content = AnyView(EmptyView())
    ///展示状态
    @Published var isActive = false
    ///状态绑定
    var isActiveBinding: Binding<Bool> {
        .init(get: { self.isActive },
              set: { self.isActive = $0 }
        )
    }

}

extension LoadingManager {
    ///直接关闭loading
    public func dismiss() {
        isActive = false
    }
    ///展示loading
    public func show<Content: View>(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = AnyView(content())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isActive = true
        }
    }
 
    private func dismissDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isActive = false
        }
    }
}

extension View {
    
    private func addLoading<Content: View>(isActive: Binding<Bool>,
                                   content: @escaping () -> Content) -> some View {
        ZStack{
            self
            ContainerView(isActive: isActive, content: { _ in content() })
        }
    }

}
