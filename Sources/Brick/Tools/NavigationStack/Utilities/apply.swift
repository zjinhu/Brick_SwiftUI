import Foundation
import SwiftUI
/// Utilty for applying a transform to a value.
/// - Parameters:
///   - transform: The transform to apply.
///   - input: The value to be transformed.
/// - Returns: The transformed value.
func apply<T>(_ transform: (inout T) -> Void, to input: T) -> T {
    var transformed = input
    transform(&transformed)
    return transformed
}

public protocol NavigatorScreen: Hashable {}

extension AnyHashable: NavigatorScreen {}


class Unobserved<Object: ObservableObject>: ObservableObject {
    let object: Object
    
    init(object: Object) {
        self.object = object
    }
}

/// Builds a view given optional data and a function for transforming the data into a view.
struct ConditionalViewBuilder<Data, DestinationView: View>: View {
    @Binding var data: Data?
    var buildView: (Data) -> DestinationView
    
    var body: some View {
        if let data {
            buildView(data)
        }
    }
}

class NonReactiveState<T> {
  var value: T

  init(value: T) {
    self.value = value
  }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *, tvOS 16.0, *)
extension View {
  @ViewBuilder
  func anyHashableNavigationDestination<D, C>(
    for data: D.Type,
    @ViewBuilder destination: @escaping (D) -> C
  ) -> some View where D: Hashable, C: View {
    if ObjectIdentifier(D.self) == ObjectIdentifier(AnyHashable.self) {
      // No need to add AnyHashable navigation destination as it's already been added as the Data
      // navigation destination.
      self
    } else {
      // Including this ensures that `PathNavigator` can always be used.
      navigationDestination(for: AnyHashable.self, destination: { DestinationBuilderView(data: $0) })
    }
  }
}
