import SwiftUI
  
/// Toast视图修饰器/Toast view modifier
extension View {
    /// 添加Toast提示/Add Toast prompt
    /// - Parameters:
    ///   - isPresented: 显示状态绑定/Display state binding
    ///   - position: 显示位置（top/bottom）/Display position (top/bottom)
    ///   - animation: 动画类型（fade/slide/scale）/Animation type (fade/slide/scale)
    ///   - duration: 显示时长（秒）/Display duration (seconds)
    ///   - offsetY: Y轴偏移量/Y-axis offset
    ///   - content: Toast内容视图/Toast content view
    /// - Returns: 应用了Toast的视图/View with Toast applied
    public func toast<ToastContent: View>(
        isPresented: Binding<Bool>,
        position: CustomToast<ToastContent>.Position = .top,
        animation: CustomToast<ToastContent>.AnimationType = .fade,
        duration: Double = 3.0,
        offsetY: CGFloat = 0,
        @ViewBuilder content: @escaping () -> ToastContent) -> some View {
            modifier(
                CustomToast(
                    isPresented: isPresented,
                    duration: duration,
                    position: position,
                    animation: animation,
                    offsetY: offsetY,
                    content: content)
            )
        }
     
}

/// 自定义Toast结构体/Custom Toast struct
/// - ToastContent: Toast内容视图类型/Toast content view type
public struct CustomToast<ToastContent: View>: ViewModifier{
    @Binding var isPresented: Bool
    /// 显示时长（秒）/Display duration (seconds)
    let duration: Double
    /// 显示位置/Display position
    let position: Position
    /// Toast内部内容/Toast inner content
    let toastInnerContent: ToastContent
    /// Y轴偏移量/Y-axis offset
    let offsetY: CGFloat
    /// 动画类型/Animation type
    let animation: AnimationType
    
    /// 初始化自定义Toast/Initialize custom Toast
    init(isPresented: Binding<Bool>,
         duration: Double,
         position: Position,
         animation: AnimationType,
         offsetY: CGFloat,
         @ViewBuilder content: @escaping () -> ToastContent) {
        self._isPresented = isPresented
        self.duration = duration
        self.position = position
        self.toastInnerContent = content()
        self.offsetY = offsetY
        self.animation = animation
    }
    
    /// Toast显示位置/Toast display position
    public enum Position {
        /// 顶部显示/Display at top
        case top
        /// 底部显示/Display at bottom
        case bottom
    }
    
    /// 动画类型/Animation type
    public enum AnimationType {
        /// 淡入淡出/Fade in and out
        case fade, 
        /// 滑动/Slide
        slide, 
        /// 缩放/Scale
        scale
    }
    
    @State private var workItem: DispatchWorkItem?
    
    private var transitionEdge: Edge {
        switch position {
        case .top :
            return .top
        case .bottom:
            return .bottom
        }
    }
    
    private var alignment: Alignment {
        switch position {
        case .top :
            return .top
        case .bottom:
            return .bottom
        }
    }
    
    /// 设置过渡动画/Set transition animation
    func setAnyTransition() -> AnyTransition{
        switch animation {
        case .fade:
            return AnyTransition.opacity.animation(.linear).combined(with: .opacity)
        case .slide:
            return AnyTransition.move(edge: transitionEdge).combined(with: .opacity)
        case .scale:
            return AnyTransition.scale.animation(.linear).combined(with: .opacity)
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: alignment){
                ZStack{
                    if isPresented{
                        toastInnerContent
                            .offset(y: offsetY)
                            .transition(setAnyTransition())
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .animation(Animation.spring(), value: isPresented)
            }
            .ss.onChange(of: isPresented) { newValue in
                if newValue{
                    onAppearAction()
                }
            }
    }
    
    /// 出现时执行的操作/Actions when appearing
    private func onAppearAction(){
        guard workItem == nil else {
            return
        }
        if duration > 0{
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                withAnimation(Animation.spring()){
                    isPresented = false
                    workItem = nil
                }
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
        }
    }
    
}
