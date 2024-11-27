//
//  DrrkModelView.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import BrickKit
#if os(iOS)
struct DarkModelView: View {
    @StateObject var colorScheme = AppColorScheme()
    var body: some View {
        List{
            Button {
                colorScheme.darkModeSetting = .dark
            } label: {
                Text("dark")
            }
            .addRightArrow()

            Button {
                colorScheme.darkModeSetting = .light
            } label: {
                Text("light")
            }
            .addRightArrow()
            
            Button {
                colorScheme.darkModeSetting = .system
            } label: {
                Text("system")
            }
            .addRightArrow()
        }
#if os(iOS)
        .ss.tabBar(.hidden)
#endif
    }
}

struct DrrkModelView_Previews: PreviewProvider {
    static var previews: some View {
        DarkModelView()
    }
}
#endif
