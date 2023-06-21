import SwiftUI

/// A scrollable `HStack` that respects elemnts like `Spacer()`
public struct HScrollStack<Content: View>: View {
    private let alignment: VerticalAlignment
    private let spacing: CGFloat?
    private let showsIndicators: Bool
    private let content: Content
    
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, showsIndicators: Bool = false, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: showsIndicators) {
            LazyHStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}
