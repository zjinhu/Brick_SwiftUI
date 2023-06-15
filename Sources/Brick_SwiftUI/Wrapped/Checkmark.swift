import SwiftUI

public extension Brick where Wrapped: View {
    func checkmark(_ visibility: Brick<Any>.Visibility) -> some View {
        wrapped.modifier(Checkmark(visibility: visibility))
    }
}

struct Checkmark: ViewModifier {
    let visibility: Brick<Any>.Visibility
    func body(content: Content) -> some View {
        switch visibility {
        case .visible:
            HStack {
                content
                Spacer()
                Image(systemName: .checkmark)
                    .foregroundColor(.accentColor)
                    .font(.callout.weight(.semibold))
            }
        default:
            content
        }
    }
}
