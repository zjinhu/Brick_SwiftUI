//
//  Refresh.swift
//  Example
//
//  Created by 狄烨 on 2023/6/18.
//

import SwiftUI
import Brick_SwiftUI
struct Refresh: View {
    struct Item: Identifiable {
        let id = UUID()
        let color: Color
        let contentHeight: CGFloat
    }
    
    @State private var items: [Item] = []
    @State private var headerRefreshing: Bool = false
    @State private var footerRefreshing: Bool = false
    @State private var noMore: Bool = false
    
    var body: some View {
        ScrollView {
            
            if items.count > 0 {
//自定义样式
//                RefreshHeader(refreshing: $headerRefreshing, action: {
//                    self.reload()
//                }) { progress in
//                    if self.headerRefreshing {
//                        SimpleRefreshingView()
//                    } else {
//                        SimplePullToRefreshView(progress: progress)
//                    }
//                }
                //默认样式
                DefaultRefreshHeader(refreshing: $headerRefreshing, refreshText: "松开刷新") {
                    self.reload()
                }
            }
            
            
            ForEach(items) { item in
                SimpleCell(item: item)
            }
             
            
            if items.count > 0 {
//自定义样式
//                RefreshFooter(refreshing: $footerRefreshing, action: {
//                    self.loadMore()
//                }) {
//                    if self.noMore {
//                        Text("No more data !")
//                            .foregroundColor(.secondary)
//                            .padding()
//                    } else {
//                        SimpleRefreshingView()
//                            .padding()
//                    }
//                }
//                .noMore(noMore)
//                .preload(offset: 50)
                //默认样式
                DefaultRefreshFooter(refreshing: $footerRefreshing, noMoreText: "没有更多数据") {
                    self.loadMore()
                }
                .noMore(noMore)
                .preload(offset: 50)
            }
        }
        .enableRefresh()
        .overlay(Group {
            if items.count == 0 {
                ProgressView()
            } else {
                EmptyView()
            }
        })
        .onAppear { self.reload() }
    }
    
    func reload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.items = Refresh.generateItems(count: 20)
            self.headerRefreshing = false
            self.noMore = false
        }
    }
    
    func loadMore() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.items += Refresh.generateItems(count: 10)
            self.footerRefreshing = false
            self.noMore = self.items.count > 50
        }
    }
    
    static func generateItems(count: Int) -> [Item] {
        (0 ..< count).map { _ in
            Item(
                color: Color(
                    red: Double.random(in: 0 ..< 255) / 255,
                    green: Double.random(in: 0 ..< 255) / 255,
                    blue: Double.random(in: 0 ..< 255) / 255
                ),
                contentHeight: CGFloat.random(in: 100 ..< 200)
            )
        }
    }
}

struct Refresh_Previews: PreviewProvider {
    static var previews: some View {
        Refresh()
    }
}

struct SimpleCell: View {
    let item: Refresh.Item
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            item.color
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(spacing: 8) {
                item.color
                    .frame(height: 30)
                    .cornerRadius(4)
                
                item.color
                    .frame(height: item.contentHeight)
                    .cornerRadius(4)
            }
        }
        .padding(.top)
    }
}
