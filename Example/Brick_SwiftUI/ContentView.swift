//
//  ContentView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import Brick_SwiftUI
struct ContentView: View {

    var body: some View {
        NavigationView {
            List{
                NavigationLink("Webview", destination: WebView(url: "https://www.qq.com"))
                
                NavigationLink("PhotoPickerView", destination: PhotoPickerView())
            }
            .ss.bottomSafeAreaInset {
                Text("12")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
