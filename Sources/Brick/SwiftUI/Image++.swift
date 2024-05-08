//
//  SwiftUIView.swift
//  
//
//  Created by iOS on 2023/6/28.
//

import SwiftUI

public extension Image {
    
    static func symbol(_ name: String) -> Image {
        .init(systemName: name)
    }
    
    init(symbol: SFSymbolName) {
        self.init(systemName: symbol.symbolName)
    }
}

public extension Image {

    /// Resize the image with a certain content mode.
    func resized(to mode: ContentMode) -> some View {
        self.resizable()
            .aspectRatio(contentMode: mode)
    }
}


extension Image {

    public func sizeToFit(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        alignment: Alignment = .center
    ) -> some View {
        resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height, alignment: alignment)
    }
    
    @_disfavoredOverload
    public func sizeToFit(
        _ size: CGSize? = nil,
        alignment: Alignment = .center
    ) -> some View {
        sizeToFit(width: size?.width, height: size?.height, alignment: alignment)
    }
    
    public func sizeToFitSquare(
        sideLength: CGFloat?,
        alignment: Alignment = .center
    ) -> some View {
        sizeToFit(width: sideLength, height: sideLength, alignment: alignment)
    }
}
