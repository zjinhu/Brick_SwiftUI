//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
import SwiftUI
import Combine

public extension View {

    func loading<LoadingContent: View>(
        isPresented: Binding<Bool>, 
        options: LoadingOptions = .init(),
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> LoadingContent) -> some View {
        self.modifier(
            CustomLoading(showLoading: isPresented, options: options, onDismiss: onDismiss, content: content)
        )
    }

}

struct CustomLoading<LoadingContent: View>: ViewModifier {
    @Binding var showLoading: Bool

    let options: LoadingOptions
    let onDismiss: (() -> Void)?

    @State private var timer: Timer?
    @State private var isInit = false
    @State private var viewState = false

    private let loadingInnerContent: LoadingContent

    @ViewBuilder
    private var loadingRenderContent: some View {
        if showLoading {
            Group {
                switch options.modifierType {
                case .scale:
                    loadingInnerContent
                        .modifier(LoadingScale(showLoading: $showLoading, options: options))
                default:
                    loadingInnerContent
                        .modifier(LoadingFade(showLoading: $showLoading, options: options))
                }
            }
            .onTapGesture(perform: dismissOnTap)
            .onAppear(perform: setup)
            .onDisappear { isInit = false }
            .onReceive(Just(showLoading), perform: update)
        }
    }

    init(
        showLoading: Binding<Bool>,
        options: LoadingOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> LoadingContent
    ) {
        self._showLoading = showLoading
        self.options = options
        self.onDismiss = onDismiss
        self.loadingInnerContent = content()
    }

    func body(content: Content) -> some View {

        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .overlay(
                Group { EmptyView() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(options.backdrop?.ignoresSafeArea())
                    .opacity(options.backdrop != nil && showLoading ? 1 : 0)
                    .onTapGesture(perform: dismissOnTap)
            )
            .overlay(loadingRenderContent, alignment: .center)
    }

    private func setup() {
        dismissAfterTimeout()
        isInit = true
    }

    private func update(state: Bool) {
        if state != viewState {
            viewState = state

            if isInit, viewState {
                dismissAfterTimeout()
            }
        }
    }

    private func dismissAfterTimeout() {
        if let timeout = options.hideAfter, showLoading, options.hideAfter != nil {
            DispatchQueue.main.async { [self] in
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { _ in dismiss() })
            }
        }
    }

    private func dismiss() {
        withAnimation(options.animation) {
            timer?.invalidate()
            timer = nil
            showLoading = false
            viewState = false

            onDismiss?()
        }
    }

    private func dismissOnTap() {
        if(options.dismissOnTap ?? true){
            self.dismiss()
        }
    }
}

protocol CustomLoadingModifier: ViewModifier {
    var showLoading: Bool { get set }
    var options: LoadingOptions? { get }
}

public struct LoadingOptions {

    public var hideAfter: TimeInterval?

    public var backdrop: Color?

    public var animation: Animation?

    public var modifierType: ModifierType

    public var dismissOnTap: Bool? = false

    public enum ModifierType {
        case fade, scale
    }

    public init(
        hideAfter: TimeInterval? = nil,
        backdrop: Color? = .black.opacity(0.4),
        animation: Animation = .linear,
        modifierType: ModifierType = .fade,
        dismissOnTap: Bool? = false
    ) {
        self.hideAfter = hideAfter
        self.backdrop = backdrop
        self.animation = animation
        self.modifierType = modifierType
        self.dismissOnTap = dismissOnTap
    }
}

struct LoadingFade: CustomLoadingModifier {
    @Binding var showLoading: Bool
    let options: LoadingOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(options?.animation ?? .linear))
            .opacity(showLoading ? 1 : 0)
            .zIndex(1)
    }
}

struct LoadingScale: CustomLoadingModifier {
    @Binding var showLoading: Bool
    let options: LoadingOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.scale.animation(options?.animation ?? .linear))
            .opacity(showLoading ? 1 : 0)
            .zIndex(1)
    }
}
