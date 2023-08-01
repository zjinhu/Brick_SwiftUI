//
//  ViewEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI

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
