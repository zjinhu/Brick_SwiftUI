//
//  OpenURLView.swift
//  Example
//
//  Created by iOS on 2023/6/12.
//

import SwiftUI
import Brick_SwiftUI
struct OpenURLView: View {
    
    @Environment(\.openURL) private var openURL
 
    var body: some View {
        List{
#if os(iOS)
            NavigationLink("Webview", destination: WebView(url: URL(string: "https://www.qq.com")!))
            
            
            Brick.Link("In-app Safari", destination: URL(string: "https://github.com/jackiehu1122/SwiftBrick")!)
                .environment(\.openURL, .init { url in
                    .safari(url) { config in
                        config.tintColor = .red
                        config.dismissStyle = .close
                        config.prefersReader = true
                        config.barCollapsingEnabled = false
                    }
                })
#endif
            Button {
                openURL(URL(string: "https://www.baidu.com")!)
            } label: {
                Text("Baidu")
            }
            
            Link("OpenURL", destination: URL(string: "https://www.baidu.com")!)
                .environment(\.openURL, .init { url in
                    print("Open \(url)")
                    return .systemAction
                })


        }
    }
}

struct OpenURLView_Previews: PreviewProvider {
    static var previews: some View {
        OpenURLView()
    }
}
