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
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            LazyVStack(alignment: alignment, spacing: spacing) {
                content
            }
        }
    }
}

public struct VScrollGrid<Content: View>: View {
    private let alignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let showsIndicators: Bool
    private let content: Content
    private let rowsCount: Int
    
    public init(rowsCount: Int,
                alignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                showsIndicators: Bool = false,
                @ViewBuilder content: () -> Content) {
        self.rowsCount = rowsCount
        self.alignment = alignment
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.content = content()
    }
    
    public var body: some View {
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: rowsCount),
                      alignment: alignment,
                      spacing: spacing){
                content
            }
        }
    }
}
