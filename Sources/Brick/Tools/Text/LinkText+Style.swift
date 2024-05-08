//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

#if os(iOS) || os(macOS) || os(watchOS)
import SwiftUI

public extension LinkText {

    /// This style can be applied to a ``LinkText`` and will
    /// apply to all links within the view.
    ///
    /// There are some built-in styles like ``standard`` and
    /// ``plain``. You can also create your own.
    ///
    /// To style colors, plain texts in a ``LinkText`` apply
    /// the currently applied `.foregroundColor` while links
    /// use the currently applied `.accentColor`. The entire
    /// component will also use other native modifiers, like
    /// `.lineSpacing`.
    struct Style {

        public init(
            fontWeight: Font.Weight = .regular,
            underline: Bool = true
        ) {
            self.fontWeight = fontWeight
            self.underline = underline
        }

        public var fontWeight: Font.Weight
        public var underline: Bool
    }
}

public extension LinkText.Style {
    
    /// The standard link text style.
    ///
    /// You can set this style to affect the global default.
    static var standard = Self()

    /// A plain link text style that doesn't underline links.
    static var plain = Self(underline: false)
}

public extension View {

    /// Apply a ``LinkText/Style`` to the view.
    func linkTextStyle(
        _ style: LinkText.Style
    ) -> some View {
        self.environment(\.linkTextStyle, style)
    }
}

private extension LinkText.Style {

    struct Key: EnvironmentKey {

        public static var defaultValue: LinkText.Style = .standard
    }
}

public extension EnvironmentValues {

    var linkTextStyle: LinkText.Style {
        get { self [LinkText.Style.Key.self] }
        set { self [LinkText.Style.Key.self] = newValue }
    }
}

#endif
