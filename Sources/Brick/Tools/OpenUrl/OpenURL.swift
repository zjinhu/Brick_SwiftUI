import SwiftUI

#if canImport(SafariServices)
import SafariServices
#endif

#if canImport(WatchKit)
import WatchKit
#endif
@MainActor
extension Brick where Wrapped == Any {
    /// An action that opens a URL.
    ///
    /// Read the ``EnvironmentValues.openURL`` environment value to get an
    /// instance of this structure for a given ``Environment``. Call the
    /// instance to open a URL. You call the instance directly because it
    /// defines a ``Brick.OpenURLAction.callAsFunction(_:)`` method that Swift
    /// calls when you call the instance.
    ///
    /// For example, you can open a web site when the user taps a button:
    ///
    ///     struct OpenURLExample: View {
    ///         @Environment(\.openURL) private var openURL
    ///
    ///         var body: some View {
    ///             Button {
    ///                 if let url = URL(string: "https://www.example.com") {
    ///                     openURL(url)
    ///                 }
    ///             } label: {
    ///                 Label("Get Help", systemImage: "person.fill.questionmark")
    ///             }
    ///         }
    ///     }
    ///
    /// If you want to know whether the action succeeds, add a completion
    /// handler that takes a Boolean value. In this case, Swift implicitly
    /// calls the ``Brick.OpenURLAction.callAsFunction(_:completion:)`` method
    /// instead. That method calls your completion handler after it determines
    /// whether it can open the URL, but possibly before it finishes opening
    /// the URL. You can add a handler to the example above so that
    /// it prints the outcome to the console:
    ///
    ///     openURL(url) { accepted in
    ///         print(accepted ? "Success" : "Failure")
    ///     }
    ///
    /// The system provides a default open URL action with behavior
    /// that depends on the contents of the URL. For example, the default
    /// action opens a Universal Link in the associated app if possible,
    /// or in the user’s default web browser if not.
    ///
    /// You can also set a custom action using the ``View.environment(_:_:)``
    /// view modifier. Any views that read the action from the environment,
    /// including the built-in ``Link`` view and ``Text`` views with markdown
    /// links, or links in attributed strings, use your action. Initialize an
    /// action by calling the ``Brick.OpenURLAction.init(handler:)`` initializer with
    /// a handler that takes a URL and returns an ``Brick.OpenURLAction.Result``:
    ///
    ///     Text("Visit [Example Company](https://www.example.com) for details.")
    ///         .environment(\.openURL, Brick.OpenURLAction { url in
    ///             handleURL(url) // Define this method to take appropriate action.
    ///             return .handled
    ///         })
    ///
    /// SwiftUI translates the value that your custom action's handler
    /// returns into an appropriate Boolean result for the action call.
    /// For example, a view that uses the action declared above
    /// receives `true` when calling the action, because the
    /// handler always returns ``Brick.OpenURLAction.Result.handled``.
    public struct OpenURLAction {

        public struct Result {
            enum Value {
                case handled
                case discarded
                case systemAction(_ url: URL?)
                
                var accepted: Bool {
                    if case .discarded = self {
                        return false
                    } else {
                        return true
                    }
                }
            }

            let value: Value

            public static var handled: Result { .init(value: .handled) }
            public static var discarded: Result { .init(value: .discarded) }
            public static var systemAction: Result { .init(value: .systemAction(nil)) }
            public static func systemAction(_ url: URL) -> Result { .init(value: .systemAction(url)) }
        }

        let handler: (URL) -> Result

        public init(handler: @escaping (URL) -> Result) {
            self.handler = handler
        }

        @MainActor @available(watchOS, unavailable)
        public func callAsFunction(_ url: URL) {
            handleUrl(url)
        }

        @MainActor @available(watchOS, unavailable)
        public func callAsFunction(_ url: URL, completion: @escaping (_ accepted: Bool) -> Void) {
            let result = handleUrl(url)
            completion(result.accepted)
        }

        @MainActor @discardableResult
        private func handleUrl(_ url: URL) -> Result.Value {
            let result = handler(url).value

            switch result {
            case .handled, .discarded: break
            case let .systemAction(updatedUrl):
                let resolved = updatedUrl ?? url
                #if os(macOS)
                NSWorkspace.shared.open(resolved)
                #elseif os(iOS) || os(tvOS)
                UIApplication.shared.open(resolved)
                #elseif os(watchOS)
                WKExtension.shared().openSystemURL(resolved)
                #endif
            }

            return result
        }
    }
}
@MainActor
private struct OpenURLKey: @preconcurrency EnvironmentKey {
    static var defaultValue: Brick<Any>.OpenURLAction {
        .init { url in
            #if os(macOS)
            return .systemAction
            #elseif os(iOS) || os(tvOS)
            if UIApplication.shared.canOpenURL(url) {
                return .systemAction
            } else {
                return .discarded
            }
            #else
            return .systemAction
            #endif
        }
    }
}
public extension EnvironmentValues {
    @_disfavoredOverload
    var openURL: Brick<Any>.OpenURLAction {
        get { self[OpenURLKey.self] }
        set { self[OpenURLKey.self] = newValue }
    }
}
