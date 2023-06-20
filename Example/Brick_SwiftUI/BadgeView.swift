//
//  Badge.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import Brick_SwiftUI
struct BadgeView: View {
    struct Badge: View {
        var body: some View {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
        }
    }

    
    var body: some View {
        VStack(spacing: 44) {

            Rectangle()
                .ss.badge(alignment: .topLeading) {
                    Badge()
                }
                .ss.badge(alignment: .topTrailing) {
                    Badge()
                }
                .ss.badge(alignment: .bottomLeading) {
                    Badge()
                }
                .ss.badge(alignment: .bottomTrailing) {
                    Badge()
                }
                .shadow(color: .black, radius: 50, x: 0, y: 0)
                .frame(width: 100, height: 100)

            HStack {
                Circle()
                    .ss.badge(alignment: .topLeading) {
                        Badge()
                    }

                Circle()
                    .ss.badge(alignment: .topTrailing) {
                        Badge()
                    }

                Circle()
                    .ss.badge(alignment: .bottomLeading) {
                        Badge()
                    }

                Circle()
                    .ss.badge(alignment: .bottomTrailing) {
                        Badge()
                    }
            }
            .padding(.horizontal)
        }
    }
}

struct BadgeView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeView()
    }
}
 
