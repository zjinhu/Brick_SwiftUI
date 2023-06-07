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
            VStack{
                NavigationLink("Webview", destination: WebView(url: "https://www.qq.com"))
                
                NavigationLink("push", destination: PhotoPickerView())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
