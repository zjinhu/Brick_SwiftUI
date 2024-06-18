//
//  SimpleToast.swift
//
//  This file is part of the SimpleToast Swift library: https://github.com/sanzaru/SimpleToast
//  Created by Martin Albrecht on 12.07.20.
//  Licensed under Apache License v2.0
//

import SwiftUI
import Combine
// MARK: - View extensions
public extension View {
    /// Present the sheet based on the state of a given binding to a boolean.
    ///
    /// - NOTE: The toast will be attached to the view's frame it is attached to and not the general UIScreen.
    /// - Parameters:
    ///   - isPresented: Boolean binding as source of truth for presenting the toast
    ///   - options: Options for the toast
    ///   - onDismiss: Closure called when the toast is dismissed
    ///   - content: Inner content for the toast
    /// - Returns: The toast view
    func toast<SimpleToastContent: View>(
        isPresented: Binding<Bool>, options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent) -> some View {
        self.modifier(
            SimpleToast(showToast: isPresented, options: options, onDismiss: onDismiss, content: content)
        )
    }

    /// Present the sheet based on the state of a given optional item.
    /// If the item is non-nil the toast will be shown, otherwise it is dimissed.
    ///
    /// - NOTE: The toast will be attached to the view's frame it is attached to and not the general UIScreen.
    /// - Parameters:
    ///   - item: Optional item as source of truth for presenting the toast
    ///   - options: Options for the toast
    ///   - onDismiss: Closure called when the toast is dismissed
    ///   - content: Inner content for the toast
    /// - Returns: The toast view
    func toast<SimpleToastContent: View, Item: Identifiable>(
        item: Binding<Item?>?, options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent
    ) -> some View {
        let bindingProxy = Binding<Bool>(
            get: { item?.wrappedValue != nil },
            set: {
                if !$0 {
                    item?.wrappedValue = nil
                }
            }
        )

        return self.modifier(
            SimpleToast(showToast: bindingProxy, options: options, onDismiss: onDismiss, content: content)
        )
    }
}

struct SimpleToast<SimpleToastContent: View>: ViewModifier {
    @Binding var showToast: Bool

    let options: SimpleToastOptions
    let onDismiss: (() -> Void)?

    @State private var timer: Timer?
    @State private var offset: CGSize = .zero
    @State private var delta: CGFloat = 0
    @State private var isInit = false
    @State private var viewState = false

    private let toastInnerContent: SimpleToastContent

    private let maxDelta: CGFloat = 20

    #if !os(tvOS)
    /// Dimiss the toast on drag
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { [self] in
                delta = 0

                switch options.alignment {
                case .top, .topLeading, .topTrailing:
                    if $0.translation.height <= offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)

                case .bottom, .bottomLeading, .bottomTrailing:
                    if $0.translation.height >= offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)

                case .leading:
                    if $0.translation.width <= offset.width {
                        offset.width = $0.translation.width
                    }
                    delta += abs(offset.width)

                case .trailing:
                    if $0.translation.width >= offset.width {
                        offset.width = $0.translation.width
                    }
                    delta += abs(offset.width)

                default:
                    if $0.translation.height < offset.height {
                        offset.height = $0.translation.height
                    }
                    delta += abs(offset.height)
                }
            }
            .onEnded { [self] _ in
                if delta >= maxDelta {
                    return dismiss()
                }

                offset = .zero
            }
    }
    #endif

    @ViewBuilder
    private var toastRenderContent: some View {
        if showToast {
            Group {
                switch options.modifierType {
                case .slide:
                    toastInnerContent
                        .modifier(SimpleToastSlide(showToast: $showToast, options: options))
                        #if !os(tvOS)
                        .gesture(dragGesture)
                        #endif

                case .scale:
                    toastInnerContent
                        .modifier(SimpleToastScale(showToast: $showToast, options: options))
                        #if !os(tvOS)
                        .gesture(dragGesture)
                        #endif
                case .skew:
                    toastInnerContent
                        .modifier(SimpleToastSkew(showToast: $showToast, options: options))
                        // .gesture(dragGesture)

//                case .curtain:
//                    toastInnerContent
//                        .modifier(SimpleToastCurtain(showToast: $showToast, options: options))
//                        .onTapGesture(perform: dismiss)

                default:
                    toastInnerContent
                        .modifier(SimpleToastFade(showToast: $showToast, options: options))
                        #if !os(tvOS)
                        .gesture(dragGesture)
                        #endif
                }
            }
            .onTapGesture(perform: dismissOnTap)
            .onAppear(perform: setup)
            .onDisappear { isInit = false }
            .onReceive(Just(showToast), perform: update)
            .offset(offset)
        }
    }

    init(
        showToast: Binding<Bool>,
        options: SimpleToastOptions,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleToastContent
    ) {
        self._showToast = showToast
        self.options = options
        self.onDismiss = onDismiss
        self.toastInnerContent = content()
    }

    func body(content: Content) -> some View {
        // Main view content
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Backdrop
            .overlay(
                Group { EmptyView() }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(options.backdrop?.edgesIgnoringSafeArea(.all))
                    .opacity(options.backdrop != nil && showToast ? 1 : 0)
                    .onTapGesture(perform: dismiss)
            )

            // Toast content
            .overlay(toastRenderContent, alignment: options.alignment)
    }

    /// Initialize the dismiss timer and set init variable
    private func setup() {
        dismissAfterTimeout()
        isInit = true
    }

    /// Update the dismiss timer if state has changed.
    ///
    /// This function is required, because the onAppear will not be triggered again until a full dismissal of the view
    /// happened. Retriggering the toast resulted in non set timers and thus never disappearing toasts.
    /// See [the GitHub issue](https://github.com/sanzaru/SimpleToast/issues/24) for more information.
    private func update(state: Bool) {
        // We need to keep track of the current view state and only update on changing values. The onReceive modifier
        // will otherwise constantly trigger updates when the toast is initialized with an Identifiable instead of Bool
        if state != viewState {
            viewState = state

            if isInit, viewState {
                dismissAfterTimeout()
            }
        }
    }

    /// Dismiss the sheet after the timeout specified in the options
    private func dismissAfterTimeout() {
        if let timeout = options.hideAfter, showToast, options.hideAfter != nil {
            DispatchQueue.main.async { [self] in
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false, block: { _ in dismiss() })
            }
        }
    }

    /// Dismiss the toast and reset all nessasary parameters
    private func dismiss() {
        withAnimation(options.animation) {
            timer?.invalidate()
            timer = nil
            showToast = false
            viewState = false
            offset = .zero

            onDismiss?()
        }
    }
    /// Dismiss the toast Base on dismissOnTap
    private func dismissOnTap() {
        if(options.dismissOnTap ?? true){
            self.dismiss()
        }
    }
}

protocol SimpleToastModifier: ViewModifier {
    var showToast: Bool { get set }
    var options: SimpleToastOptions? { get }
}

public struct SimpleToastOptions {
    /// Alignment of the toast (e.g. .top)
    public var alignment: Alignment

    /// TimeInterval defining the time after which the toast will be hidden.
    /// nil is default, which is equivalent to no hiding
    public var hideAfter: TimeInterval?

    /// Flag determining if the backsdrop is shown
    @available(swift, deprecated: 0.5.1, renamed: "backdrop")
    public var showBackdrop: Bool? = false

    /// Color of the backdrop. Will be ignoroed when no backdrop is shown
    @available(swift, deprecated: 0.5.1, renamed: "backdrop")
    public var backdropColor: Color = Color.white

    public var backdrop: Color?

    /// Custom animation type
    public var animation: Animation?

    /// The type of SimpleToast modifier to apply
    public var modifierType: ModifierType

    /// Flag dismiss on tap
    public var dismissOnTap: Bool? = false

    /// All available modifier types
    public enum ModifierType {
        case fade, slide, scale, skew
    }

    public init(
        alignment: Alignment = .top,
        hideAfter: TimeInterval? = nil,
        backdrop: Color? = nil,
        animation: Animation = .linear,
        modifierType: ModifierType = .fade,
        dismissOnTap: Bool? = true
    ) {
        self.alignment = alignment
        self.hideAfter = hideAfter
        self.backdrop = backdrop
        self.animation = animation
        self.modifierType = modifierType
        self.dismissOnTap = dismissOnTap

    }
}

// MARK: - Deprecated
extension SimpleToastOptions {
    @available(swift, deprecated: 0.5.1, renamed: "init(alignment:hideAfter:backdrop:animation:modifierType:dismissOnTap:)")
    public init(
        alignment: Alignment = .top,
        hideAfter: TimeInterval? = nil,
        showBackdrop: Bool? = true,
        backdropColor: Color = Color.white.opacity(0.9),
        animation: Animation? = nil,
        modifierType: ModifierType = .fade,
        dismissOnTap: Bool? = true

    ) {
        self.alignment = alignment
        self.hideAfter = hideAfter
        self.showBackdrop = showBackdrop
        self.backdropColor = backdropColor
        self.animation = animation
        self.modifierType = modifierType
        self.dismissOnTap = dismissOnTap
    }
}

struct SimpleToastFade: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.opacity.animation(options?.animation ?? .linear))
            .opacity(showToast ? 1 : 0)
            .zIndex(1)
    }
}

struct SimpleToastScale: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    func body(content: Content) -> some View {
        content
            .transition(AnyTransition.scale.animation(options?.animation ?? .linear))
            .opacity(showToast ? 1 : 0)
            .zIndex(1)
    }
}

private struct RotationModifier: ViewModifier {
    let amount: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                Angle(degrees: amount),
                axis: (x: 1.0, y: 0.01, z: 0.01),
                anchor: .top,
                perspective: 1.0
            )
    }
}

extension AnyTransition {
    static var skew: AnyTransition {
        .modifier(
            active: RotationModifier(amount: 90),
            identity: RotationModifier(amount: 0)
        )
    }
}

/// Modifier for the skewing animation
struct SimpleToastSkew: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    func body(content: Content) -> some View {
        content
            .transition(
                AnyTransition.skew
                    .combined(with: .scale(scale: 0.01, anchor: .top))
                    .animation(options?.animation ?? .linear)
            )
            .zIndex(1)
    }
}

struct SimpleToastSlide: SimpleToastModifier {
    @Binding var showToast: Bool
    let options: SimpleToastOptions?

    private var transitionEdge: Edge {
        if let pos = options?.alignment ?? nil {
            switch pos {
            case .top, .topLeading, .topTrailing:
                return .top

            case .bottom, .bottomLeading, .bottomTrailing:
                return .bottom

            default:
                return .top
            }
        }

        return .top
    }

    func body(content: Content) -> some View {
        return content
            .transition(AnyTransition.move(edge: transitionEdge).combined(with: .opacity))
            .animation(options?.animation ?? .default)
            .zIndex(1)
    }
}

