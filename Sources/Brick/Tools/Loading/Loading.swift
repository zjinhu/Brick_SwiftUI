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

    @State private var workItem: DispatchWorkItem?

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
            .overlay(
                Group { EmptyView() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(options.backdrop?.ignoresSafeArea())
                    .opacity(options.backdrop != nil && showLoading ? 1 : 0)
                    .onTapGesture(perform: dismissOnTap)
            )
            .overlay(alignment: .center){
                loadingRenderContent
            }
            .onChange(of: showLoading) { newValue in
                if newValue{
                    dismissAfterTimeout()
                }
            }
    }

    private func dismissAfterTimeout() {
        if let timeout = options.hideAfter, showLoading, options.hideAfter != nil {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismiss()
            }
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout, execute: task)
        }
    }

    private func dismiss() {
        withAnimation(options.animation) {
            showLoading = false
            workItem = nil
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
