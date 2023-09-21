//
//  DefaultFooter.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

extension Refresh {
    
    public struct DefaultFooter: View {
        
        let action: () -> Void
        
        @Binding var refreshing: Bool
        
        var noMoreText: String
        
        private var noMore: Bool = false
        private var preloadOffset: CGFloat = 0
        
        public init(refreshing: Binding<Bool>,
                    noMoreText: String,
                    action: @escaping () -> Void) {
            self.action = action
            self.noMoreText = noMoreText
            self._refreshing = refreshing
        }
        
        @Environment(\.refreshFooterUpdate) var update
    }
}


extension Refresh.DefaultFooter {
    
    public func noMore(_ noMore: Bool) -> Self {
        var view = self
        view.noMore = noMore
        return view
    }
    
    public func preload(offset: CGFloat) -> Self {
        var view = self
        view.preloadOffset = offset
        return view
    }
}

extension Refresh.DefaultFooter{
    
    public var body: some View {
        if !noMore, update.refresh, !refreshing {
            DispatchQueue.main.async {
                self.refreshing = true
                self.action()
            }
        }
        
        return Group {
            if update.enable {
                VStack(alignment: .center, spacing: 0) {
                    if refreshing || noMore {
                        if noMore {
                            Text(noMoreText)
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            ProgressView()
                                .padding()
                        }
                    } else {
                        EmptyView()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                EmptyView()
            }
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .anchorPreference(key: Refresh.FooterAnchorKey.self, value: .bounds) {
            if self.noMore || self.refreshing {
                return []
            } else {
                return [.init(bounds: $0, preloadOffset: self.preloadOffset, refreshing: self.refreshing)]
            }
        }
    }
}
