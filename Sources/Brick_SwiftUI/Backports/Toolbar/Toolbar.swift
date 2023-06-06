#if os(iOS)
import SwiftUI

public extension Brick<Any> {
    enum ToolbarItemPlacement {
        case automatic
        case primaryAction
        case confirmationAction
        case cancellationAction
        case destructiveAction
        case principal
        case bottomBar

        var isLeading: Bool {
            switch self {
            case .cancellationAction:
                return true
            default:
                return false
            }
        }

        var isTrailing: Bool {
            switch self {
            case .automatic, .primaryAction, .confirmationAction, .destructiveAction:
                return true
            default:
                return false
            }
        }
    }

    struct ToolbarItem: View {
        let id: String
        let placement: Brick.ToolbarItemPlacement
        let content: AnyView

        public init<Content: View>(id: String = UUID().uuidString, placement: Brick.ToolbarItemPlacement = .automatic, @ViewBuilder content: () -> Content) {
            self.id = id
            self.placement = placement
            self.content = AnyView(content())
        }

        public var body: some View {
            content.id(id)
        }
    }
}

extension Collection where Element == Brick<Any>.ToolbarItem, Indices: RandomAccessCollection, Indices.Index: Hashable {
    @ViewBuilder var content: some View {
        if !isEmpty {
            HStack {
                ForEach(indices, id: \.self) { index in
                    self[index].content
                }
            }
        }
    }
}
private extension Brick where Wrapped: View {
    func largeScale() -> some View {
        #if os(macOS)
        if #available(macOS 11, *) {
            wrapped.imageScale(.large)
        } else {
            wrapped
        }
        #else
        wrapped.imageScale(.large)
        #endif
    }
}

public extension Brick<Any> {
    @resultBuilder struct ToolbarContentBuilder { }
}

public extension Brick<Any>.ToolbarContentBuilder {
    static func buildBlock() -> [Brick<Any>.ToolbarItem] {
        [.init(content: EmptyView.init)]
    }

    static func buildBlock(_ content: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [content]
    }

    static func buildIf(_ content: Brick<Any>.ToolbarItem?) -> [Brick<Any>.ToolbarItem?] {
        [content].compactMap { $0 }
    }

    static func buildEither(first: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [first]
    }

    static func buildEither(second: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [second]
    }

    static func buildLimitedAvailability(_ content: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [content]
    }

    static func buildBlock(_ c0: Brick<Any>.ToolbarItem, _ c1: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [c0, c1]
    }

    static func buildBlock(_ c0: Brick<Any>.ToolbarItem, _ c1: Brick<Any>.ToolbarItem, _ c2: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [c0, c1, c2]
    }

    static func buildBlock(_ c0: Brick<Any>.ToolbarItem, _ c1: Brick<Any>.ToolbarItem, _ c2: Brick<Any>.ToolbarItem, _ c3: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [c0, c1, c2, c3]
    }

    static func buildBlock(_ c0: Brick<Any>.ToolbarItem, _ c1: Brick<Any>.ToolbarItem, _ c2: Brick<Any>.ToolbarItem, _ c3: Brick<Any>.ToolbarItem, _ c4: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [c0, c1, c2, c3, c4]
    }

    static func buildBlock(_ c0: Brick<Any>.ToolbarItem, _ c1: Brick<Any>.ToolbarItem, _ c2: Brick<Any>.ToolbarItem, _ c3: Brick<Any>.ToolbarItem, _ c4: Brick<Any>.ToolbarItem, _ c5: Brick<Any>.ToolbarItem) -> [Brick<Any>.ToolbarItem] {
        [c0, c1, c2, c3, c4, c5]
    }
}
#endif
