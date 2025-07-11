//
//  LinearProgressBar+Style.swift
//
//  Created by iOS on 2023/6/28.
//
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
import SwiftUI
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension LinearProgressBar {

    /// This type can style a ``LinearProgressBar``.
    struct Style {

        public init(
            animation: Animation = .bouncy,
            height: Double = 10,
            backgroundMaterial: Material = .ultraThin,
            backgroundMaterialOpacity: Double = 1,
            backgroundColor: Color = .clear,
            barColor: Color = .accentColor,
            barPadding: Double = 0,
            barShadow: ViewShadowStyle = .progressBar
        ) {
            self.animation = animation
            self.height = height
            self.backgroundColor = backgroundColor
            self.backgroundMaterial = backgroundMaterial
            self.backgroundMaterialOpacity = backgroundMaterialOpacity
            self.barColor = barColor
            self.barPadding = barPadding
            self.barShadow = barShadow
        }

        public typealias ViewModifier = (AnyView) -> AnyView

        public var animation: Animation
        public var height: Double
        public var backgroundMaterial: Material
        public var backgroundMaterialOpacity: Double
        public var backgroundColor: Color
        public var barColor: Color
        public var barPadding: Double
        public var barShadow: ViewShadowStyle
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
@MainActor
public extension LinearProgressBar.Style {

    /// The standard liear progress bar style.
    ///
    /// You can set this style to affect the global default.
    static var standard = Self()

    /// A style that adds padding to the bar.
    static var padding = Self(barPadding: 2)

    /// A style that makes the bar tall and adds padding.
    static var tallPadding = Self(height: 16, barPadding: 3)
}

public extension ViewShadowStyle {

    /// This style can be used with ``LinearProgressBar``.
    static let progressBar = Self(
        color: .black.opacity(0.4),
        radius: 2,
        x: 1
    )
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension View {

    /// Apply a ``LinearProgressBar/Style`` to the view.
    func linearProgressBarStyle(
        _ style: LinearProgressBar.Style
    ) -> some View {
        self.environment(\.linearProgressBarStyle, style)
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private extension LinearProgressBar.Style {

    struct Key: @preconcurrency EnvironmentKey {

        @MainActor public static var defaultValue: LinearProgressBar.Style = .standard
    }
}
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension EnvironmentValues {

    var linearProgressBarStyle: LinearProgressBar.Style {
        get { self [LinearProgressBar.Style.Key.self] }
        set { self [LinearProgressBar.Style.Key.self] = newValue }
    }
}
#endif
