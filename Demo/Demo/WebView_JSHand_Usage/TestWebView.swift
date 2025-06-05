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
            Color.gray.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            WebView(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Test", ofType: "html")!))
                .showProgress(true)
                .clearBackgroundColor()
                .additionalConfiguration { webView in
                    webView.evaluateJavaScript("navigator.userAgent") { result, error in
                        if let ua = result as? String {
                            webView.customUserAgent = ua + " xxxxxxxx"
                        }
                    }
                    webView.evaluateJavaScript("document.title") { (result, error) in
                        print("xxxxxx-----\(String(describing: result))")
                    }
                }
                .onMessageHandler(name: "iosBridge"){ message in
                    print("xxxxxx-----\(String(describing: message))")
                }
        }
    }
}

#Preview {
    TestWebView()
}
#endif
