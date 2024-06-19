//This file is part of the SSToastMessage Swift library: https://github.com/SimformSolutionsPvtLtd/SSToastMessage
import SwiftUI

extension View {
    
    public func toast<ToastContent: View>(
        isPresented: Binding<Bool>,
        type: CustomToast<ToastContent>.ToastType = .alert,
        position: CustomToast<ToastContent>.Position = .bottom,
        animation: Animation? = Animation.easeOut(duration: 0.3),
        horizontalPadding: CGFloat? = 0,
        duration: Double? = 3.0,
        closeOnTap: Bool = true,
        closeOnTapOutside: Bool = false,
        onTap: (() -> Void)? = nil,
        onToastDismiss: (() -> Void)? = nil,
        view: @escaping () -> ToastContent) -> some View {
            self.modifier(
                CustomToast(
                    isPresented: isPresented,
                    type: type,
                    position: position,
                    animation: animation,
                    duration: duration,
                    horizontalPadding: horizontalPadding,
                    closeOnTap: closeOnTap,
                    onTap: onTap ?? {},
                    onToastDismiss: onToastDismiss ?? {},
                    closeOnTapOutside: closeOnTapOutside,
                    view: view)
            )
        }
    
}

class DispatchWorkHolder {
    var work: DispatchWorkItem?
}

class CustomToastModel: ObservableObject {
    @Published var updateView: Bool = false
    @Published var isLeftRightToastView: Bool = false
}

public struct CustomToast<ToastContent>: ViewModifier where ToastContent: View {
    
    @ObservedObject var viewModel = CustomToastModel()
    
    public enum ToastType: Equatable {
        case alert
        case toast
        case floater(_ verticalPadding: CGFloat = 50)
        case leftToastView
        case rightToastView
        
        func shouldBeCentered() -> Bool {
            switch self {
            case .alert:
                return true
            default:
                return false
            }
        }
    }
    
    public enum Position {
        
        case top
        case bottom
    }
    
    @Binding var isPresented: Bool
    
    var type: ToastType
    
    var position: Position
    
    var animation: Animation?
    
    var duration: Double?
    
    var horizontalPadding: CGFloat?
    
    var closeOnTap: Bool
    
    var onTap: () -> Void
    
    var onToastDismiss: () -> Void
    
    var closeOnTapOutside: Bool
    
    @State var leftToastMessage: Bool = false
    
    @State var rightToastMessage: Bool = false
    
    var view: () -> ToastContent
    
    @State private var viewHeight: CGFloat = .zero
    @State private var viewWidth: CGFloat = .zero
    
    var dispatchWorkHolder = DispatchWorkHolder()
    
    @State private var presenterContentRect: CGRect = .zero
    
    @State private var sheetContentRect: CGRect = .zero
    
    @State private var offset: CGFloat = 0
    
    @State var toastViewWidth: CGFloat = 0
    
    @State var toastViewHeight: CGFloat = 0
    
    private var displayedOffset: CGFloat {
        switch type {
        case .alert:
            return  -presenterContentRect.midY + viewHeight/2
        case .toast:
            if position == .bottom {
                return viewHeight - presenterContentRect.midY - sheetContentRect.height/2
            } else {
                return -presenterContentRect.midY + sheetContentRect.height/2
            }
        case .floater(let verticalPadding):
            if position == .bottom {
                return viewHeight - presenterContentRect.midY - sheetContentRect.height/2 - verticalPadding
            } else {
                return -presenterContentRect.midY + sheetContentRect.height/2 + verticalPadding
            }
        case .leftToastView, .rightToastView:
            if position == .bottom {
                return leftRightToastViewPosition - 30
            } else {
                return -(leftRightToastViewPosition - 60)
            }
        }
    }
    
    private var hiddenOffset: CGFloat {
        if position == .top {
            if presenterContentRect.isEmpty {
                return -1000
            }
#if targetEnvironment(macCatalyst)
            return -presenterContentRect.midY - sheetContentRect.height/2 - 300
#else
            return -presenterContentRect.midY - sheetContentRect.height/2 - 5
#endif
        } else {
            if presenterContentRect.isEmpty {
                return 1000
            }
#if targetEnvironment(macCatalyst)
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 300
#else
            return screenHeight - presenterContentRect.midY + sheetContentRect.height/2 + 5
#endif
        }
    }
    
    private var leftRightToastViewPosition: CGFloat {
        viewHeight/2 - toastViewHeight/2
    }
    
    private var currentOffset: CGFloat {
        return isPresented ? displayedOffset : hiddenOffset
    }
    
    private var screenHeight: CGFloat {
#if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size.height
#elseif os(macOS)
        return NSScreen.main?.frame.height ?? 0
#elseif os(iOS)
        return UIScreen.main.bounds.size.height
#endif
    }
    
    private var screenWidth: CGFloat {
#if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size.width
#elseif os(macOS)
        return  NSScreen.main?.frame.width ?? 0
#elseif os(iOS)
        return UIScreen.main.bounds.size.width
#endif
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            ZStack {
                content
                    .background(
                        GeometryReader { proxy -> AnyView in
                            let rect = proxy.frame(in: .global)
                            // This avoids an infinite layout loop
                            if rect.integral != self.presenterContentRect.integral {
                                DispatchQueue.main.async {
                                    viewModel.updateView = true
                                    self.presenterContentRect = rect
                                }
                            }
                            return AnyView(EmptyView())
                        }
                    )
                    .overlay(presentSheet())
#if !(os(macOS))
                    .navigationBarHidden(true)
#endif
                if closeOnTapOutside {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.isPresented = false
                        }
                        .opacity(isPresented ? 0.5 : 0)
                }
            }.onReceive(viewModel.$updateView, perform: { _ in
                viewHeight = proxy.size.height
#if os(macOS) || targetEnvironment(macCatalyst)
                viewWidth = proxy.size.width - (horizontalPadding ?? 0)
#elseif os(iOS)
                viewWidth = screenWidth - (horizontalPadding ?? 0)
#endif
            })
            .onAppear {
                if type == .leftToastView {
                    setLeftToastOffset()
                } else if type == .rightToastView  {
                    setRightToastOffset()
                }
            }
            .onChange(of: isPresented) { updatedValue in
                if !updatedValue {
                    leftToastMessage = false
                    rightToastMessage = false
                } else {
                    leftToastMessage = type == .leftToastView
                    rightToastMessage = type == .rightToastView
                }
                setLeftRightToastOffset()
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
    
    func presentSheet() -> some View {
        
        if let duration = duration, !(type == .leftToastView || type == .rightToastView) {
            dispatchWorkHolder.work?.cancel()
            dispatchWorkHolder.work = DispatchWorkItem(block: {
                self.isPresented = false
                self.onToastDismiss()
            })
            if isPresented, let work = dispatchWorkHolder.work {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: work)
            }
        }
        
        let commonVStack = VStack {
            self.view()
                .simultaneousGesture(TapGesture().onEnded {
                    if self.closeOnTap {
                        DispatchQueue.main.async {
                            self.isPresented = false
                            self.onTap()
                        }
                    }
                })
                .background(
                    GeometryReader { proxy -> AnyView in
                        let rect = proxy.frame(in: .global)
                        // This avoids an infinite layout loop
                        if rect.integral != self.sheetContentRect.integral {
                            DispatchQueue.main.async {
                                self.sheetContentRect = rect
                                toastViewWidth = proxy.size.width
                                toastViewHeight = proxy.size.height
                            }
                        }
                        return AnyView(EmptyView())
                    }
                )
                .offset(x: (leftToastMessage || rightToastMessage) ? offset : 0, y: (leftToastMessage || rightToastMessage) ? displayedOffset : currentOffset)
                .onReceive(viewModel.$isLeftRightToastView, perform: { _ in
                    
                    if leftToastMessage || rightToastMessage {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if rightToastMessage {
#if os(macOS) || targetEnvironment(macCatalyst)
                                offset = (viewWidth / 2) - toastViewWidth / 2 - 10
#elseif os(iOS)
                                offset = (screenWidth / 2) - toastViewWidth / 2 - 10
#endif
                            } else if leftToastMessage {
#if os(macOS) || targetEnvironment(macCatalyst)
                                offset = -((viewWidth / 2) - toastViewWidth / 2 - 10)
#elseif os(iOS)
                                offset = -((screenWidth / 2) - toastViewWidth / 2) + 10
#endif
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + (duration ?? 0)) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                setLeftRightToastOffset()
                            }
                        }
                        
                        Timer.scheduledTimer(withTimeInterval: ((duration ?? 0) + 0.5), repeats: false) { _ in
                            onToastDismiss()
                            isPresented = false
                        }
                    }
                })
        }
        
        return ZStack{
            Group {
                if !(leftToastMessage || rightToastMessage) {
                    commonVStack
                        .frame(width: viewWidth)
                        .animation(animation, value: isPresented)
                        .opacity(isPresented ? 1 : 0)
                } else {
                    commonVStack
                }
            }
        }
    }
    
    func setLeftRightToastOffset() {
        if leftToastMessage {
            setLeftToastOffset()
        } else if rightToastMessage {
            setRightToastOffset()
        }
    }
    
    func setLeftToastOffset() {
#if os(macOS)
        offset = -(NSScreen.main?.frame.size.width ?? 0)
#elseif os(iOS)
        offset = -UIScreen.main.bounds.width
#endif
    }
    
    func setRightToastOffset() {
#if os(macOS)
        offset = NSScreen.main?.frame.size.width ?? 0
#elseif os(iOS)
        offset = UIScreen.main.bounds.width
#endif
    }
}
