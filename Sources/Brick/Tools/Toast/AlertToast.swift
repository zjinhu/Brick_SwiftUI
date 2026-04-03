//This file is part of the AlertToast Swift library: https://github.com/elai950/AlertToast
// 提示吐司组件/Alert Toast component
// 支持多种显示模式：Alert、HUD、Banner/Supports multiple display modes: Alert, HUD, Banner

import SwiftUI
#if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
/// AlertToast提示组件/AlertToast prompt component
public struct AlertToast: View{
    
    /// 横幅动画类型/Banner animation type
    public enum BannerAnimation{
        case slide, pop
    }
    
    /// 显示模式/Display mode
    public enum DisplayMode: Equatable{
        /// 弹窗模式/Alert mode
        case alert
        /// HUD模式（居中显示）/HUD mode (center display)
        case hud
        /// 横幅模式（顶部或底部）/Banner mode (top or bottom)
        case banner(_ transition: BannerAnimation)
    }
    
    /// 提示类型/Prompt type
    public enum AlertType: Equatable{
        /// 系统图标（SF Symbol）/System image (SF Symbol)
        case systemImage(_ name: String, _ color: Color)
        /// 自定义图片/Custom image
        case image(_ name: String, _ color: Color)
        /// 常规模式（仅文字）/Regular mode (text only)
        case regular
        /// 加载中/Loading
        case loading
    }
    
    /// 提示样式/Prompt style
    public enum AlertStyle: Equatable{
        
        case style(backgroundColor: Color? = nil,
                   titleColor: Color? = nil,
                   subTitleColor: Color? = nil,
                   titleFont: Font? = nil,
                   subTitleFont: Font? = nil)
        
        var backgroundColor: Color? {
            switch self{
            case .style(backgroundColor: let color, _, _, _, _):
                return color
            }
        }
        
        var titleColor: Color? {
            switch self{
            case .style(_,let color, _,_,_):
                return color
            }
        }
        
        var subtitleColor: Color? {
            switch self{
            case .style(_,_, let color, _,_):
                return color
            }
        }
        
        var titleFont: Font? {
            switch self {
            case .style(_, _, _, titleFont: let font, _):
                return font
            }
        }
        
        var subTitleFont: Font? {
            switch self {
            case .style(_, _, _, _, subTitleFont: let font):
                return font
            }
        }
    }
    
    public var displayMode: DisplayMode = .alert
    
    public var type: AlertType
    
    public var title: String? = nil
    
    public var subTitle: String? = nil
    
    public var style: AlertStyle? = nil
    
    public init(displayMode: DisplayMode = .alert,
                type: AlertType,
                title: String? = nil,
                subTitle: String? = nil,
                style: AlertStyle? = nil){
        
        self.displayMode = displayMode
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.style = style
    }
    
    public init(displayMode: DisplayMode,
                type: AlertType,
                title: String? = nil){
        
        self.displayMode = displayMode
        self.type = type
        self.title = title
    }
    
    public var banner: some View{
        VStack{
            Spacer()
            
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    switch type{
                    case .systemImage(let name, let color):
                        Image(systemName: name)
                            .foregroundColor(color)
                    case .image(let name, let color):
                        Image(name)
                            .renderingMode(.template)
                            .foregroundColor(color)
                    case .regular:
                        EmptyView()
                    case .loading:
                        ProgressView()
                            .tintColor(style?.titleColor)
                    }
                    
                    Text(LocalizedStringKey(title ?? ""))
                        .font(style?.titleFont ?? Font.headline.bold())
                }
                
                if subTitle != nil{
                    Text(LocalizedStringKey(subTitle!))
                        .font(style?.subTitleFont ?? Font.subheadline)
                }
            }
            .multilineTextAlignment(.leading)
            .textColor(style?.titleColor ?? nil)
            .padding()
            .frame(maxWidth: 400, alignment: .leading)
            .alertBackground(style?.backgroundColor ?? nil)
            .cornerRadius(10)
            .padding([.horizontal, .bottom])
        }
    }
    
    public var hud: some View{
        Group{
            HStack(spacing: 16){
                switch type{
                case .systemImage(let name, let color):
                    Image(systemName: name)
                        .hudModifier()
                        .foregroundColor(color)
                case .image(let name, let color):
                    Image(name)
                        .hudModifier()
                        .foregroundColor(color)
                case .regular:
                    EmptyView()
                    
                case .loading:
                    ProgressView()
                        .tintColor(style?.titleColor)
                }
                
                if title != nil || subTitle != nil{
                    VStack(alignment: type == .regular ? .center : .leading, spacing: 2){
                        if title != nil{
                            Text(LocalizedStringKey(title ?? ""))
                                .font(style?.titleFont ?? Font.body.bold())
                                .multilineTextAlignment(.center)
                                .textColor(style?.titleColor ?? nil)
                        }
                        if subTitle != nil{
                            Text(LocalizedStringKey(subTitle ?? ""))
                                .font(style?.subTitleFont ?? Font.footnote)
                                .opacity(0.7)
                                .multilineTextAlignment(.center)
                                .textColor(style?.subtitleColor ?? nil)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .frame(minHeight: 50)
            .alertBackground(style?.backgroundColor ?? nil)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 6)
            .compositingGroup()
        }
        .padding(.top)
    }
    
    public var alert: some View{
        VStack{
            switch type{
            case .systemImage(let name, let color):
                Spacer()
                Image(systemName: name)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .foregroundColor(color)
                    .padding(.bottom)
                Spacer()
            case .image(let name, let color):
                Spacer()
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
                    .foregroundColor(color)
                    .padding(.bottom)
                Spacer()
            case .regular:
                EmptyView()
            case .loading:
                ProgressView()
                    .tintColor(style?.titleColor)
                    .padding(.bottom, 5)
            }
            
            VStack(spacing: type == .regular ? 8 : 2){
                if title != nil{
                    Text(LocalizedStringKey(title ?? ""))
                        .font(style?.titleFont ?? Font.body.bold())
                        .multilineTextAlignment(.center)
                        .textColor(style?.titleColor ?? nil)
                }
                if subTitle != nil{
                    Text(LocalizedStringKey(subTitle ?? ""))
                        .font(style?.subTitleFont ?? Font.footnote)
                        .opacity(0.7)
                        .multilineTextAlignment(.center)
                        .textColor(style?.subtitleColor ?? nil)
                }
            }
        }
        .padding()
        .withFrame(type != .regular && type != .loading)
        .alertBackground(style?.backgroundColor ?? nil)
        .cornerRadius(10)
    }
    
    ///Body init determine by `displayMode`
    public var body: some View{
        switch displayMode{
        case .alert:
            alert
        case .hud:
            hud
        case .banner:
            banner
        }
    }
}

/// AlertToast修饰器/AlertToast modifier
public struct AlertToastModifier: ViewModifier{
    
    /// 显示状态绑定/Presentation `Binding<Bool>`
    @Binding var isPresenting: Bool
    
    /// 显示时长（秒）/Duration time to display the alert
    @State var duration: Double = 2
    
    /// 点击关闭/Tap to dismiss alert
    @State var tapToDismiss: Bool = true
    
    /// Y轴偏移量/Y-axis offset
    var offsetY: CGFloat = 0
    
    /// AlertToast视图构建闭包/Init `AlertToast` View
    var alert: () -> AlertToast
    
    /// 点击回调/Completion block returns `true` after dismiss
    var onTap: (() -> ())? = nil
    /// 完成回调/Completion callback
    var completion: (() -> ())? = nil
    
    @State private var workItem: DispatchWorkItem?
    
    @State private var hostRect: CGRect = .zero
    @State private var alertRect: CGRect = .zero
 
    private var offset: CGFloat{
        return -hostRect.midY + alertRect.height
    }
    
    @ViewBuilder
    public func main() -> some View{
        if isPresenting{
            
            switch alert().displayMode{
            case .alert:
                alert()
                    .onTapGesture {
                        onTap?()
                        if tapToDismiss{
                            withAnimation(Animation.spring()){
                                self.workItem?.cancel()
                                isPresenting = false
                                self.workItem = nil
                            }
                        }
                    }
                    .onDisappear{
                        completion?()
                    }
                    .transition(AnyTransition.scale(scale: 0.8).combined(with: .opacity))
            case .hud:
                alert()
                    .overlay(
                        GeometryReader{ geo -> AnyView in
                            let rect = geo.frame(in: .global)
                            
                            if rect.integral != alertRect.integral{
                                
                                DispatchQueue.main.async {
                                    
                                    self.alertRect = rect
                                }
                            }
                            return AnyView(EmptyView())
                        }
                    )
                    .onTapGesture {
                        onTap?()
                        if tapToDismiss{
                            withAnimation(Animation.spring()){
                                self.workItem?.cancel()
                                isPresenting = false
                                self.workItem = nil
                            }
                        }
                    }
                    .onDisappear{
                        completion?()
                    }
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            case .banner:
                alert()
                    .onTapGesture {
                        onTap?()
                        if tapToDismiss{
                            withAnimation(Animation.spring()){
                                self.workItem?.cancel()
                                isPresenting = false
                                self.workItem = nil
                            }
                        }
                    }
                    .onDisappear{
                        completion?()
                    }
                    .transition(alert().displayMode == .banner(.slide) ? AnyTransition.slide.combined(with: .opacity) : AnyTransition.move(edge: .bottom))
            }
            
        }
    }
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        switch alert().displayMode{
        case .banner:
            content
                .overlay(
                    ZStack{
                        main()
                            .offset(y: offsetY)
                    }
                        .animation(Animation.spring(), value: isPresenting)
                )
                .valueChanged(value: isPresenting, onChange: { (presented) in
                    if presented{
                        onAppearAction()
                    }
                })
        case .hud:
            content
                .overlay(
                    GeometryReader{ geo -> AnyView in
                        let rect = geo.frame(in: .global)
                        
                        if rect.integral != hostRect.integral{
                            DispatchQueue.main.async {
                                self.hostRect = rect
                            }
                        }
                        
                        return AnyView(EmptyView())
                    }
                        .overlay(
                            ZStack{
                                main()
                                    .offset(y: offsetY)
                            }
                                .frame(maxWidth: Screen.width, maxHeight: Screen.height)
                                .offset(y: offset)
                                .animation(Animation.spring(), value: isPresenting))
                )
                .valueChanged(value: isPresenting, onChange: { (presented) in
                    if presented{
                        onAppearAction()
                    }
                })
        case .alert:
            content
                .overlay(
                    ZStack{
                        main()
                            .offset(y: offsetY)
                    }
                        .frame(maxWidth: Screen.width, maxHeight: Screen.height, alignment: .center)
                        .edgesIgnoringSafeArea(.all)
                        .animation(Animation.spring(), value: isPresenting))
                .valueChanged(value: isPresenting, onChange: { (presented) in
                    if presented{
                        onAppearAction()
                    }
                })
        }
        
    }
    
    private func onAppearAction(){
        guard workItem == nil else {
            return
        }
        
        if alert().type == .loading{
            duration = 0
            tapToDismiss = false
        }
        
        if duration > 0{
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                withAnimation(Animation.spring()){
                    isPresenting = false
                    workItem = nil
                }
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
        }
    }
}

fileprivate struct WithFrameModifier: ViewModifier{
    
    var withFrame: Bool
    
    var maxWidth: CGFloat = 175
    var maxHeight: CGFloat = 175
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if withFrame{
            content
                .frame(maxWidth: maxWidth, maxHeight: maxHeight, alignment: .center)
        }else{
            content
        }
    }
}

fileprivate struct BackgroundModifier: ViewModifier{
    
    var color: Color?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        
        if let color = color {
            content
                .background(color)
        }else{
            content
                .background(BlurView())
        }
        
    }
}

fileprivate struct TextForegroundModifier: ViewModifier{
    
    var color: Color?
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if color != nil{
            content
                .foregroundColor(color)
        }else{
            content
        }
    }
}

fileprivate extension Image{
    
    func hudModifier() -> some View{
        self
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 20, maxHeight: 20, alignment: .center)
    }
}

public extension View{
    
    fileprivate func withFrame(_ withFrame: Bool) -> some View{
        modifier(WithFrameModifier(withFrame: withFrame))
    }
    
    /// 应用AlertToast提示/Apply AlertToast prompt
    /// - Parameters:
    ///   - isPresenting: 显示状态绑定/Display state binding
    ///   - duration: 显示时长（秒）/Display duration (seconds)
    ///   - tapToDismiss: 是否点击关闭/Whether tap to dismiss
    ///   - offsetY: Y轴偏移量/Y-axis offset
    ///   - alert: AlertToast构建闭包/AlertToast build closure
    ///   - onTap: 点击回调/Tap callback
    ///   - completion: 完成回调/Completion callback
    /// - Returns: 应用了提示的视图/View with prompt applied
    func toast(isPresenting: Binding<Bool>, 
               duration: Double = 2,
               tapToDismiss: Bool = true,
               offsetY: CGFloat = 0,
               alert: @escaping () -> AlertToast,
               onTap: (() -> ())? = nil,
               completion: (() -> ())? = nil) -> some View{
        modifier(
            AlertToastModifier(isPresenting: isPresenting,
                               duration: duration,
                               tapToDismiss: tapToDismiss,
                               offsetY: offsetY,
                               alert: alert,
                               onTap: onTap,
                               completion: completion)
        )
    }
    
    fileprivate func alertBackground(_ color: Color? = nil) -> some View{
        modifier(BackgroundModifier(color: color))
    }
    
    fileprivate func textColor(_ color: Color? = nil) -> some View{
        modifier(TextForegroundModifier(color: color))
    }
    
    @ViewBuilder fileprivate func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        self.ss.onChange(of: value, onChange)
    }
}

#endif
