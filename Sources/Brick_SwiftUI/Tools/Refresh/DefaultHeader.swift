//
//  DefaultHeader.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

extension Refresh {

    public struct DefaultHeader: View{
        
        let action: () -> Void

        @Binding var refreshing: Bool
        
        var refreshText: String

        public init(refreshing: Binding<Bool>,
                    refreshText: String,
                    action: @escaping () -> Void) {
            self.action = action
            self.refreshText = refreshText
            self._refreshing = refreshing
        }
        
        @Environment(\.refreshHeaderUpdate) var update
    }
}

extension Refresh.DefaultHeader{
    
    public var body: some View {
        if update.refresh, !refreshing, update.progress > 1.01 {
            DispatchQueue.main.async {
                self.refreshing = true
                self.action()
            }
        }
        
        return Group {
            if update.enable {
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    Group {
                        if refreshing {
                            ProgressView()
                        } else {
                            Text(refreshText)
                        }
                    }
                    .opacity(opacity)
     
                }
                .frame(maxWidth: .infinity)
            } else {
                EmptyView()
            }
        }
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        .anchorPreference(key: Refresh.HeaderAnchorKey.self, value: .bounds) {
            [.init(bounds: $0, refreshing: self.refreshing)]
        }
    }
    
    var opacity: Double {
        (!refreshing && update.refresh) || (update.progress == 0) ? 0 : 1
    }
}

