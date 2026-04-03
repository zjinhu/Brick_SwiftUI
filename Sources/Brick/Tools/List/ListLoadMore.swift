//
//  LoadMoreView.swift
//  MetagAI
//
//  Created by iOS on 10/18/24.
//

import SwiftUI

/// 加载更多视图/Load more view
/// 加载更多触发器，需要放在LazyVStack中才可以生效。/Load more trigger, must be placed in LazyVStack to work.
public struct LoadMoreView: View {
    /// 加载更多操作/Load more action
    public let loadMore: () -> Void
    
    /// 初始化加载更多视图/Initialize load more view
    /// - Parameter loadMore: 加载更多时调用的闭包/Closure to call when loading more
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
