import SwiftUI

public extension Brick where Wrapped: View {
    func checkmark(_ visibility: Visibility) -> some View {
        wrapped.modifier(Checkmark(visibility: visibility))
    }
}

struct Checkmark: ViewModifier {
    let visibility: Visibility
    func body(content: Content) -> some View {
        switch visibility {
        case .visible:
            HStack {
                content
                Spacer()
                Image(symbol: .checkmark)
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
        HStack(spacing: 10){
            Image(symbol: configuration.isOn ? .checkmarkSquareFill : .square)
                .imageScale(.large)
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
