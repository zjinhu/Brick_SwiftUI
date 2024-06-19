import SwiftUI
 
extension View {
    
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

public struct CustomToast<ToastContent: View>: ViewModifier{
    @Binding var isPresented: Bool
    let duration: Double
    let position: Position
    let toastInnerContent: ToastContent
    let offsetY: CGFloat
    let animation: AnimationType
    
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
    
    public enum Position {
        case top
        case bottom
    }
    
    public enum AnimationType {
        case fade, slide, scale
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
                .animation(Animation.spring(), value: isPresented)
            }
            .onChange(of: isPresented) { newValue in
                if newValue{
                    onAppearAction()
                }
            }
    }
    
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
