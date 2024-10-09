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
