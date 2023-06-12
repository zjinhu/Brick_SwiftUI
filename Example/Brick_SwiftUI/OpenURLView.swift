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
            NavigationLink("Webview", destination: WebView(url: "https://www.qq.com"))
 
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
            
            Brick.Link("In-app Safari", destination: URL(string: "https://github.com/shaps80/SwiftUIBackports")!)
                .environment(\.openURL, .init { url in
                    .safari(url) { config in
                        config.tintColor = .red
                        config.dismissStyle = .close
                        config.prefersReader = true
                        config.barCollapsingEnabled = false
                    }
                })

        }
    }
}

struct OpenURLView_Previews: PreviewProvider {
    static var previews: some View {
        OpenURLView()
    }
}
