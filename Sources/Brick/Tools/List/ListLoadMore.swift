//
//  LoadMoreView.swift
//  MetagAI
//
//  Created by iOS on 10/18/24.
//

import SwiftUI
///需要放在LazyVStack中才可以生效，否则会出现BUG
public struct LoadMoreView: View {
    public let loadMore: () -> Void
    public init(loadMore: @escaping () -> Void) {
        self.loadMore = loadMore
    }
    
    public var body: some View {
        Color.clear
            .frame(height: 20)
            .onAppear(perform: loadMore)
    }
}

#Preview {
    LoadMoreView{}
}
