import SwiftUI

/// A scrollable `VStack` that respects elemnts like `Spacer()`
public struct VScrollStack<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let showsIndicators: Bool
    private let content: Content

    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, showsIndicators: Bool = false, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
    }

    public var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical, showsIndicators: showsIndicators) {
                LazyVStack(alignment: alignment, spacing: spacing) {
                    content
                }
                .frame(
                    maxWidth: geo.size.width,
                    minHeight: geo.size.height
                )
            }
        }
    }
}
