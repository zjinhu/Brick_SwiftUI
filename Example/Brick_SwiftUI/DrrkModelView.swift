//
//  DrrkModelView.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
import Brick_SwiftUI
struct DrrkModelView: View {
    @StateObject var colorScheme = AppColorScheme()
    var body: some View {
        List{
            Button {
                colorScheme.darkModeSetting = .dark
            } label: {
                Text("dark")
            }
            .rightArrow()

            Button {
                colorScheme.darkModeSetting = .light
            } label: {
                Text("light")
            }
            .rightArrow()
            
            Button {
                colorScheme.darkModeSetting = .system
            } label: {
                Text("system")
            }
            .rightArrow()
        }
    }
}

struct DrrkModelView_Previews: PreviewProvider {
    static var previews: some View {
        DrrkModelView()
    }
}
