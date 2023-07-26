//
//  HScrollStackView.swift
//  Example
//
//  Created by 狄烨 on 2023/6/21.
//

import SwiftUI
import Brick_SwiftUI
struct ScrollStackView: View {
    var body: some View {
        VStack{
            VScrollStack{
                ForEach(0..<30) { i in
                    Text("\(i)")
                        .width(30)
                        .height(50)
                }
            }
            .maxWidth(30)
            .height(300)
            .background(Color.orange)
            
            HScrollStack{
                ForEach(0..<30) { i in
                    Text("\(i)")
                        .width(80)
                        .height(30)
                }
            }
            .maxWidth(300)
            .height(30)
            .background(Color.orange)
        }
#if !os(xrOS) && os(iOS)
        .ss.tabBar(.hidden)
#endif

    }
}

struct ScrollStackView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollStackView()
    }
}
