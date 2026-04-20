//
//  SwiftUIView.swift
//  
//
//  Created by 狄烨 on 2023/10/8.
//

import SwiftUI

/// 简单加载视图/Easy loading view
/// 简单的加载遮罩视图，支持自定义前景色、背景色、阴影色和遮罩色。/Simple loading overlay view with customizable foreground, background, shadow and mask colors.
/// - Content: 内容视图类型/Content view type
/// - LoadingView: 加载视图类型/Loading view type
public struct EasyLoadingView<Content: View, LoadingView: View>: View{

    @Environment(\.easyLoadingForegroundColor) private var easyLoadingForegroundColor
    @Environment(\.easyLoadingBackgroundColor) private var easyLoadingBackgroundColor
    @Environment(\.easyLoadingShadowColor) private var easyLoadingShadowColor
    @Environment(\.easyLoadingMaskColor) private var easyLoadingMaskColor
    
    /// 显示状态绑定/Display state binding
    @Binding var isShowing: Bool
    /// 内容视图闭包/Content view closure
    private var content: () -> Content
    /// 加载视图闭包/Loading view closure
    private var loadingView: () -> LoadingView
    
    /// 初始化简单加载视图/Initialize easy loading view
    /// - Parameters:
    ///   - isShowing: 显示状态绑定/Display state binding
    ///   - loading: 加载视图构建闭包/Loading view builder closure
    ///   - content: 内容视图构建闭包/Content view builder closure
    public init(isShowing: Binding<Bool>,
                @ViewBuilder loading: @escaping () -> LoadingView,
                @ViewBuilder content: @escaping () -> Content) {
        self._isShowing = isShowing
        self.content = content
        self.loadingView = loading
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            
            self.content() 
            
#if os(iOS) || os(tvOS)
            if let maskColor = easyLoadingMaskColor{
                maskColor
                    .opacity(isShowing ? 1 : 0)
                    .ignoresSafeArea()
            }else{
                GlassmorphismBlurView()
                    .opacity(isShowing ? 1 : 0)
                    .ignoresSafeArea()
            }
#else
            if let maskColor = easyLoadingMaskColor{
                maskColor
                    .opacity(isShowing ? 1 : 0)
                    .ignoresSafeArea()
            }else{
                Color.black.opacity(0.5)
                    .opacity(isShowing ? 1 : 0)
                    .ignoresSafeArea()
            }
#endif
            
            ZStack{
                easyLoadingBackgroundColor
 
                loadingView()
                    .padding(20)
            }
            .fixedSize()
            .cornerRadius(10)
            .opacity(isShowing ? 1 : 0)
            .shadow(color: easyLoadingShadowColor, radius: 5)

        }
        .edgesIgnoringSafeArea(.all)
    }
}

/// 前景色环境键/Foreground color environment key
struct EasyLoadingForegroundColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .white
}
/// 背景色环境键/Background color environment key
struct EasyLoadingBackgroundColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .black
}
/// 阴影色环境键/Shadow color environment key
struct EasyLoadingShadowColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color = .gray
}
/// 遮罩色环境键/Mask color environment key
struct EasyLoadingMaskColorEnvironmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Color?
}
extension EnvironmentValues {
    /// 前景色/Foreground color
    var easyLoadingForegroundColor: Color {
        get { self[EasyLoadingForegroundColorEnvironmentKey.self] }
        set { self[EasyLoadingForegroundColorEnvironmentKey.self] = newValue }
    }
    /// 背景色/Background color
    var easyLoadingBackgroundColor: Color {
        get { self[EasyLoadingBackgroundColorEnvironmentKey.self] }
        set { self[EasyLoadingBackgroundColorEnvironmentKey.self] = newValue }
    }
    /// 阴影色/Shadow color
    var easyLoadingShadowColor: Color {
        get { self[EasyLoadingShadowColorEnvironmentKey.self] }
        set { self[EasyLoadingShadowColorEnvironmentKey.self] = newValue }
    }
    /// 遮罩色/Mask color
    var easyLoadingMaskColor: Color? {
        get { self[EasyLoadingMaskColorEnvironmentKey.self] }
        set { self[EasyLoadingMaskColorEnvironmentKey.self] = newValue }
    }
}

/// View扩展/View extension
extension View {
    /// 设置前景色/Set foreground color
    public func easyLoadingForegroundColor(_ color: Color) -> some View {
        environment(\.easyLoadingForegroundColor, color)
    }
    /// 设置背景色/Set background color
    public func easyLoadingBackgroundColor(_ color: Color) -> some View {
        environment(\.easyLoadingBackgroundColor, color)
    }
    /// 设置阴影色/Set shadow color
    public func easyLoadingShadowColor(_ color: Color) -> some View {
        environment(\.easyLoadingShadowColor, color)
    }
    /// 设置遮罩色/Set mask color
    public func easyLoadingMaskColor(_ color: Color?) -> some View {
        environment(\.easyLoadingMaskColor, color)
    }
}

#Preview {
    EasyLoadingView(isShowing: .constant(true)) {
        ProgressView()
            .tintColor(.primary)
    } content: {
        NavigationView {
            List(["1", "2", "3", "4", "5"], id: \.self) { row in
                Text(row)
            }
        }
    }
    .easyLoadingBackgroundColor(.defaultBackground)
    .easyLoadingShadowColor(.clear)
    .easyLoadingForegroundColor(.green)
    .easyLoadingMaskColor(.clear)
}
