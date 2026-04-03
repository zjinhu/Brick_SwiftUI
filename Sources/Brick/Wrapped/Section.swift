import SwiftUI

/// iOS 15+ 已废弃
/// iOS 15+ deprecated
@available(iOS, deprecated: 15)
@available(tvOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(watchOS, deprecated: 8)

/// Brick 扩展：Section 容器
/// Brick extension: Section container
extension Brick where Wrapped == Any {

    /// A container view that you can use to add hierarchy to certain collection views.
    ///
    /// Use `Section` instances in views like ``List``, ``Picker``, and
    /// ``Form`` to organize content into separate sections.
    public struct Section<Parent: View, Content: View, Footer: View>: View {
        @ViewBuilder let content: () -> Content
        @ViewBuilder let header: () -> Parent
        @ViewBuilder let footer: () -> Footer

        public var body: some View {
            SwiftUI.Section(
                content: content,
                header: header,
                footer: footer
            )
        }
    }
}

/// Section 扩展初始化 (仅包含内容)
/// Section extension init (content only)
@available(iOS, deprecated: 15)
@available(tvOS, deprecated: 15)
@available(macOS, deprecated: 12)
@available(watchOS, deprecated: 8)
extension Brick.Section where Wrapped == Any, Parent == Text, Footer == EmptyView {

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - titleKey: The key for the section's localized title
    ///   - content: The section's content.
    public init(_ titleKey: LocalizedStringKey, @ViewBuilder content: @escaping () -> Content) {
        self.header = { Text(titleKey) }
        self.content = content
        self.footer = { EmptyView() }
    }

    /// Creates a section with the provided section content.
    /// - Parameters:
    ///   - title: A string that describes the contents of the section.
    ///   - content: The section's content.
    public init<S>(_ title: S, @ViewBuilder content: @escaping () -> Content) where S: StringProtocol {
        self.header = { Text(title) }
        self.content = content
        self.footer = { EmptyView() }
    }

}
