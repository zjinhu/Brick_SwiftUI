//
//  NavigationStack.swift
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
    
    public struct NavigationStack<Content: View, Data: Hashable>: View {
        @Binding var externalTypedPath: [Data]
        @State var internalTypedPath: [Data] = []
        @StateObject var path : NavigationPathHolder
        @StateObject var destinationBuilder = DestinationBuilderHolder()
        @Environment(\.useNavigationStack) var useNavigationStack
        
        @State var appIsActive = NonReactiveState(value: true)
        
        var content: Content
        var useInternalTypedPath: Bool
        
        var isUsingNavigationView: Bool {
            if #available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *), useNavigationStack == .whenAvailable {
                return false
            } else {
                return true
            }
        }
        
        @ViewBuilder
        var navigation: some View {
            
            if #available(iOS 16.0, *, macOS 13.0, *, watchOS 9.0, *, tvOS 16.0, *),
               useNavigationStack == .whenAvailable {
                SwiftUI.NavigationStack(path: $path.path) {
                    content
                        .navigationDestination(for: AnyHashable.self, destination: { DestinationBuilderView(data: $0) })
                        .navigationDestination(for: LocalDestinationID.self, destination: { DestinationBuilderView(data: $0) })
                }
                .environment(\.isWithinNavigationStack, true)
                
            }else{
                NavigationView {
                    Router(rootView: content, screens: $path.path)
                }
                .navigationViewStyle(supportedNavigationViewStyle)
                .environment(\.isWithinNavigationStack, false)
            }
        }
        
        public var body: some View {
            navigation
                .environmentObject(path)
                .environmentObject(Unobserved(object: path))
                .environmentObject(destinationBuilder)
                .environmentObject(Navigator(useInternalTypedPath ? $internalTypedPath : $externalTypedPath))
                .onFirstAppear {
                    guard isUsingNavigationView else {
                        // Path should already be correct thanks to initialiser.
                        return
                    }
                    // For NavigationView, only initialising with one pushed screen is supported.
                    // Any others will be pushed one after another with delays.
                    path.path = Array(path.path.prefix(1))
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = externalTypedPath
                    }
                }
                .onChange(of: externalTypedPath) { externalTypedPath in
                    guard isUsingNavigationView else {
                        path.path = externalTypedPath
                        return
                    }
                    guard appIsActive.value else { return }
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = externalTypedPath
                    }
                }
                .onChange(of: internalTypedPath) { internalTypedPath in
                    guard isUsingNavigationView else {
                        path.path = internalTypedPath
                        return
                    }
                    guard appIsActive.value else { return }
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = internalTypedPath
                    }
                }
                .onChange(of: path.path) { path in
                    if useInternalTypedPath {
                        guard path != internalTypedPath.map({ $0 }) else { return }
                        internalTypedPath = path.compactMap { anyHashable in
                            if let data = anyHashable.base as? Data {
                                return data
                            } else if anyHashable.base is LocalDestinationID {
                                return nil
                            }
                            fatalError("Cannot add \(type(of: anyHashable.base)) to stack of \(Data.self)")
                        }
                    } else {
                        guard path != externalTypedPath.map({ $0 }) else { return }
                        externalTypedPath = path.compactMap { anyHashable in
                            if let data = anyHashable.base as? Data {
                                return data
                            } else if anyHashable.base is LocalDestinationID {
                                return nil
                            }
                            fatalError("Cannot add \(type(of: anyHashable.base)) to stack of \(Data.self)")
                        }
                    }
                }
#if os(iOS)
                .onReceive(NotificationCenter.default.publisher(for: didBecomeActive)) { _ in
                    appIsActive.value = true
                    guard isUsingNavigationView else { return }
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = useInternalTypedPath ? internalTypedPath : externalTypedPath
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: willResignActive)) { _ in
                    appIsActive.value = false
                }
#elseif os(tvOS)
                .onReceive(NotificationCenter.default.publisher(for: didBecomeActive)) { _ in
                    appIsActive.value = true
                    guard isUsingNavigationView else { return }
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = useInternalTypedPath ? internalTypedPath : externalTypedPath
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: willResignActive)) { _ in
                    appIsActive.value = false
                }
#endif
        }
        
        public init(path: Binding<[Data]>?, @ViewBuilder content: () -> Content) {
            _externalTypedPath = path ?? .constant([])
            self.content = content()
            _path = StateObject(wrappedValue: NavigationPathHolder(path: path?.wrappedValue ?? []))
            useInternalTypedPath = path == nil
        }
    }
    
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
extension Brick.NavigationStack where Wrapped == Any, Data == AnyHashable{
    public init(@ViewBuilder content: () -> Content) {
        self.init(path: nil, content: content)
    }
}

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
extension Brick.NavigationStack where Wrapped == Any, Data == AnyHashable {
    public init(path: Binding<Brick.NavigationPath>, @ViewBuilder content: () -> Content) {
        let path = Binding(
            get: { path.wrappedValue.elements },
            set: { path.wrappedValue.elements = $0 }
        )
        self.init(path: path, content: content)
    }
}

public enum UseNavigationStackPolicy {
    case whenAvailable
    case never
}

var supportedNavigationViewStyle: some NavigationViewStyle {
#if os(macOS)
    .automatic
#else
    .stack
#endif
}

#if os(iOS)
private let didBecomeActive = UIApplication.didBecomeActiveNotification
private let willResignActive = UIApplication.willResignActiveNotification
#elseif os(tvOS)
private let didBecomeActive = UIApplication.didBecomeActiveNotification
private let willResignActive = UIApplication.willResignActiveNotification
#endif
