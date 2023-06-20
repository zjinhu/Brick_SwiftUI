//
//  NavigationStack.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/6/6.
//

import SwiftUI
@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(watchOS, deprecated: 9)
@available(macOS, deprecated: 13)
extension Brick where Wrapped == Any {
    
    public struct NavigationStack<Content: View, Data: Hashable>: View {
        @Binding var externalTypedPath: [Data]
        @State var internalTypedPath: [Data] = []
        @StateObject var path = NavigationPathHolder()
        @StateObject var pathAppender = PathAppender()
        @StateObject var destinationBuilder = DestinationBuilderHolder()
        var content: Content
        var useInternalTypedPath: Bool
        
        var navigation: some View {
            pathAppender.append = { [weak path] newElement in
                path?.path.append(newElement)
            }
            return NavigationWrapper {
                Router(rootView: content, screens: $path.path)
            }
            .environmentObject(path)
            .environmentObject(pathAppender)
            .environmentObject(destinationBuilder)
            .environmentObject(Navigator(useInternalTypedPath ? $internalTypedPath : $externalTypedPath))
        }
        
        public var body: some View {
            navigation
                .onFirstAppear {
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = externalTypedPath
                    }
                }
                .onChange(of: externalTypedPath) { externalTypedPath in
                    path.withDelaysIfUnsupported(\.path) {
                        $0 = externalTypedPath
                    }
                }
                .onChange(of: internalTypedPath) { internalTypedPath in
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
        }
        
        public init(path: Binding<[Data]>?, @ViewBuilder content: () -> Content) {
            _externalTypedPath = path ?? .constant([])
            self.content = content()
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


