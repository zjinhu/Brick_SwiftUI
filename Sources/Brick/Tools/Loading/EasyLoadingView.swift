//
//  SwiftUIView.swift
//  
//
//  Created by 狄烨 on 2023/10/8.
//

import SwiftUI
public struct EasyLoadingView<Content: View, LoadingView: View>: View{

    @Environment(\.easyLoadingForegroundColor) private var easyLoadingForegroundColor
    @Environment(\.easyLoadingBackgroundColor) private var easyLoadingBackgroundColor
    @Environment(\.easyLoadingShadowColor) private var easyLoadingShadowColor
    
    @Binding var isShowing: Bool
    private var content: () -> Content
    private var loadingView: () -> LoadingView
    
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
            
#if os(iOS) || os(macOS) || os(tvOS) || targetEnvironment(macCatalyst)
            BlurView()
                .opacity(isShowing ? 1 : 0)
                .ignoresSafeArea()
#else
            Color.black.opacity(0.5)
                .opacity(isShowing ? 1 : 0)
                .ignoresSafeArea()
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

struct EasyLoadingForegroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .white
}
struct EasyLoadingBackgroundColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .black
}
struct EasyLoadingShadowColorEnvironmentKey: EnvironmentKey {
    static var defaultValue: Color = .gray
}
extension EnvironmentValues {
    var easyLoadingForegroundColor: Color {
        get { self[EasyLoadingForegroundColorEnvironmentKey.self] }
        set { self[EasyLoadingForegroundColorEnvironmentKey.self] = newValue }
    }
    var easyLoadingBackgroundColor: Color {
        get { self[EasyLoadingBackgroundColorEnvironmentKey.self] }
        set { self[EasyLoadingBackgroundColorEnvironmentKey.self] = newValue }
    }
    var easyLoadingShadowColor: Color {
        get { self[EasyLoadingShadowColorEnvironmentKey.self] }
        set { self[EasyLoadingShadowColorEnvironmentKey.self] = newValue }
    }
}

extension View {
    public func easyLoadingForegroundColor(_ color: Color) -> some View {
        environment(\.easyLoadingForegroundColor, color)
    }
    public func easyLoadingBackgroundColor(_ color: Color) -> some View {
        environment(\.easyLoadingBackgroundColor, color)
    }
    public func easyLoadingShadowColor(_ color: Color) -> some View {
        environment(\.easyLoadingShadowColor, color)
    }
}

#Preview {
    EasyLoadingView(isShowing: .constant(true)) {
        ProgressView()
    } content: {
        NavigationView {
            List(["1", "2", "3", "4", "5"], id: \.self) { row in
                Text(row)
            }
        }
    }
    .easyLoadingBackgroundColor(.red)
}
