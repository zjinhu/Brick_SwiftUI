//
//  NavigationLink.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/6/6.
//
import SwiftUI
@available(iOS, deprecated: 16, message: "Use SwiftUI's Navigation API iOS 16")
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
extension Brick where Wrapped == Any {
    public struct NavigationLink<P: Hashable, Label: View>: View {
        var value: P?
        var label: Label
        
        @EnvironmentObject var pathHolder: Unobserved<NavigationPathHolder>
        
        public init(value: P?, @ViewBuilder label: () -> Label) {
            self.value = value
            self.label = label()
        }
        
        public var body: some View {
            // TODO: Ensure this button is styled more like a NavigationLink within a List.
            // See: https://gist.github.com/tgrapperon/034069d6116ff69b6240265132fd9ef7
            Button(
                action: {
                    guard let value = value else { return }
                    pathHolder.object.path.append(value)
                },
                label: { label }
            )
        }
    }
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
public extension Brick.NavigationLink where Wrapped == Any, Label == Text {
    init(_ titleKey: LocalizedStringKey, value: P?) {
        self.init(value: value) { Text(titleKey) }
    }
    
    @_disfavoredOverload init<S>(_ title: S, value: P?) where S: StringProtocol {
        self.init(value: value) { Text(title) }
    }
}
