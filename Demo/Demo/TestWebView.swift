//
//  TestWebView.swift
//  BrickBrickDemo
//
//  Created by iOS on 9/19/24.
//

import SwiftUI
#if os(iOS)
import BrickKit
struct TestWebView: View {
    var body: some View {
        ZStack{
            Color.red
                .edgesIgnoringSafeArea(.all)
            
            WebView(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Test", ofType: "html")!))
                .showLoader(true)
                .onMessageHandler(name: "iosBridge"){ message in
                    print("xxxxxx-----\(message)")
                }
        }
    }
}

#Preview {
    TestWebView()
}
#endif
