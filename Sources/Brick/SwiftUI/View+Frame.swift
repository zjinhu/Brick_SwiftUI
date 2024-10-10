//
//  SwiftUIView.swift
//
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

extension View {
    @inlinable
    public func minWidth(_ width: CGFloat?) -> some View {
        frame(minWidth: width)
    }
    
    @inlinable
    public func maxWidth(_ width: CGFloat?) -> some View {
        frame(maxWidth: width)
    }
    
    @inlinable
    public func minHeight(_ height: CGFloat?) -> some View {
        frame(minHeight: height)
    }
    
    @inlinable
    public func maxHeight(_ height: CGFloat?) -> some View {
        frame(maxHeight: height)
    }
    
    @inlinable
    public func frame(min dimensionLength: CGFloat,
                      axis: Axis) -> some View {
        switch axis {
        case .horizontal:
            return frame(minWidth: dimensionLength)
        case .vertical:
            return frame(minWidth: dimensionLength)
        }
    }
}


extension View {
    @inlinable
    public func width(_ width: CGFloat?) -> some View {
        frame(width: width)
    }
    
    @inlinable
    public func height(_ height: CGFloat?) -> some View {
        frame(height: height)
    }
    
    @inlinable
    public func frame(_ size: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(width: size?.width,
              height: size?.height,
              alignment: alignment)
    }
    
    @inlinable
    public func frame(min size: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(minWidth: size?.width,
              minHeight: size?.height,
              alignment: alignment)
    }
    
    @inlinable
    public func frame(max size: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(maxWidth: size?.width,
              maxHeight: size?.height,
              alignment: alignment)
    }
    
    @inlinable
    public func frame(min minSize: CGSize?,
                      max maxSize: CGSize?,
                      alignment: Alignment = .center) -> some View {
        frame(minWidth: minSize?.width,
              maxWidth: maxSize?.width,
              minHeight: minSize?.height,
              maxHeight: maxSize?.height,
              alignment: alignment)
    }
    
    @_disfavoredOverload
    public func frame(width: ClosedRange<CGFloat>? = nil,
                      idealWidth: CGFloat? = nil,
                      height: ClosedRange<CGFloat>? = nil,
                      idealHeight: CGFloat? = nil) -> some View {
        frame(minWidth: width?.lowerBound,
              idealWidth: idealWidth,
              maxWidth: width?.upperBound,
              minHeight: height?.lowerBound,
              idealHeight: idealHeight,
              maxHeight: height?.upperBound)
    }
}

extension View {
    @inlinable
    public func relativeHeight(_ ratio: CGFloat,
                               alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self.frame(height: geometry.size.height * ratio,
                       alignment: alignment)
        }
    }
    
    @inlinable
    public func relativeWidth(_ ratio: CGFloat,
                              alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self.frame(width: geometry.size.width * ratio,
                       alignment: alignment)
        }
    }
    
    @inlinable
    public func relativeSize(width widthRatio: CGFloat?,
                             height heightRatio: CGFloat?,
                             alignment: Alignment = .center) -> some View {
        GeometryReader { geometry in
            self.frame(width: widthRatio.map({ $0 * geometry.size.width }),
                       height: heightRatio.map({ $0 * geometry.size.height }),
                       alignment: alignment)
        }
    }
}

public extension View {
    func readHeight(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(heightReader)
            .onPreferenceChange(ReadSizePreferenceKey.self, perform: action)
    }
    
    func readWidth(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(widthReader)
            .onPreferenceChange(ReadSizePreferenceKey.self, perform: action)
    }
}

private extension View {
    var heightReader: some View {
        GeometryReader {
            Color.clear
                .preference(key: ReadSizePreferenceKey.self, value: $0.size.height)
        }
    }
    
    var widthReader: some View {
        GeometryReader {
            Color.clear
                .preference(key: ReadSizePreferenceKey.self, value: $0.size.width)
        }
    }
}

fileprivate struct ReadSizePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

public struct GetSizeModifier: ViewModifier {
    
    @Binding
    public var currentSize: CGSize
    
    public init(currentSize: Binding<CGSize>) {
        self._currentSize = currentSize
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            currentSize = geometry.size
                        }
                        .ss.onChange(of: geometry.size) { newSize in
                            currentSize = newSize
                        }
                }
            )
    }
    
}

extension View {
    
    @inlinable
    public func idealFrame(width: CGFloat?,
                           height: CGFloat?) -> some View {
        frame(idealWidth: width,
              idealHeight: height)
    }
    
    @inlinable
    public func idealMinFrame(width: CGFloat?,
                              maxWidth: CGFloat? = nil,
                              height: CGFloat?,
                              maxHeight: CGFloat? = nil) -> some View {
        frame(minWidth: width,
              idealWidth: width,
              maxWidth: maxWidth,
              minHeight: height,
              idealHeight: height,
              maxHeight: maxHeight)
    }
}


extension View {
    @inlinable
    public func squareFrame(sideLength: CGFloat?,
                            alignment: Alignment = .center) -> some View {
        frame(width: sideLength,
              height: sideLength,
              alignment: alignment)
    }
    
    @inlinable
    public func squareFrame() -> some View {
        GeometryReader { geometry in
            self.frame(width: geometry.size.minimumDimensionLength,
                       height: geometry.size.minimumDimensionLength)
        }
    }
}

extension View {
    @inlinable
    public func frameZeroClipped(_ clipped: Bool = true) -> some View {
        frame(clipped ? .zero : nil)
            .clipped()
    }
}
