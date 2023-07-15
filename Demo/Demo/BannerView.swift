//
//  BannerView.swift
//  Example
//
//  Created by 狄烨 on 2023/6/18.
//

import SwiftUI
import Brick_SwiftUI
let roles = ["Image_Guide_1", "Image_Guide_2", "Image_Guide_3", "Image_Guide_3", "Image_Guide_2", "Image_Guide_1"]

struct BannerView: View {
    @State var spacing: CGFloat = 10
    @State var headspace: CGFloat = 10
    @State var sidesScaling: CGFloat = 0.9
    @State var isWrap: Bool = true
    @State var autoScroll: Bool = true
    @State var time: TimeInterval = 5
    @State var currentIndex: Int = 0
    var body: some View {
        VStack {
            Text("\(currentIndex + 1)/\(roles.count)")
            Spacer().frame(height: 40)
            CarouselView(roles,
                      id: \.self,
                      index: $currentIndex,
                      spacing: spacing,
                      headspace: headspace,
                      sidesScaling: sidesScaling,
                      isWrap: isWrap,
                      autoScroll: autoScroll ? .active(time) : .inactive) { name in

                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .onTapGesture {
                            debugPrint("\(name)")
                        }
                        .background(.gray)
                        .cornerRadius(30)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            Spacer()
        }
#if !os(xrOS)
        .ss.tabBar(.hidden)
#endif
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
