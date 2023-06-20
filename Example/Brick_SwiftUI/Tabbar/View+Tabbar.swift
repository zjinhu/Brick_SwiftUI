
import SwiftUI

extension View {

    @ViewBuilder func visibility(_ visibility: TabBarVisibility) -> some View {
        switch visibility {
        case .visible:
            self.transition(.move(edge: .bottom))
        case .hidden:
            hidden().transition(.move(edge: .bottom))
        }
    }
}

public enum TabBarVisibility: CaseIterable {
    case visible
    case hidden
    public mutating func toggle() {
        switch self {
        case .visible:
            self = .hidden
        case .hidden:
            self = .visible
        }
    }
}
