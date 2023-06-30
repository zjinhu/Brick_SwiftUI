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

#if os(iOS)
extension ToggleStyle where Self == CheckboxToggleStyle {
 
    public static var checkmark: CheckboxToggleStyle { CheckboxToggleStyle() }
}

public struct CheckboxToggleStyle: ToggleStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {

            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: configuration.isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }

            configuration.label
        }
    }
}
#endif
