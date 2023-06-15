//
//  SafeAreaPadding.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import Brick_SwiftUI
struct SafeAreaPaddingView: View {
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
                .ss.safeAreaPadding(24)

            Color.blue
                .ss.safeAreaPadding(24)
                .ignoresSafeArea()

            Color.yellow
                .ss.safeAreaPadding(24)
        }
    }
}

struct SafeAreaPadding_Previews: PreviewProvider {
    static var previews: some View {
        SafeAreaPaddingView()
    }
}
 
