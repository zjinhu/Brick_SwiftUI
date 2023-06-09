//
//  ContentView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import Brick_SwiftUI
struct ContentView: View {

    @State private var showSettings = false
    
    @Environment(\.openURL) private var openURL
    @State private var showDiscarded: Bool = false
    @State private var showHandled: Bool = false

    
    var body: some View {
        NavigationView {
            List{
                NavigationLink("Webview", destination: WebView(url: "https://www.qq.com"))
                
                NavigationLink("PhotoPickerView", destination: PhotoPickerView())
                
                NavigationLink("AsyncImage", destination: ImageView())
                
                Brick.ShareLink(item: "Can I share this?") {
                    Text("ShareLink")
                }
                .buttonStyle(.plain)

                Brick.ShareLink(item: "Some text to share")
                Brick.ShareLink("ShareLink", item: URL(string: "https://benkau.com")!)
                
                Button {
                    showSettings.toggle()
                } label: {
                    Text("Sheet")
                }
                
                Button {
                    openURL(URL(string: "https://www.baidu.com")!)
                } label: {
                    Text("Baidu")
                }
                
                Link("Shaps Benkau", destination: URL(string: "https://benkau.com")!)
                    .environment(\.openURL, Brick.OpenURLAction { url in
                        print("Open \(url)")
                        return .systemAction
                    })
                Link("In-app Safari", destination: URL(string: "https://github.com/shaps80/SwiftUIBackports")!)
                    .environment(\.openURL, Brick.OpenURLAction.init { url in
                        .safari(url) { config in
                            config.tintColor = .red
                            config.dismissStyle = .close
                            config.prefersReader = true
                            config.barCollapsingEnabled = false
                        }
                    })
   
            }
            .sheet(isPresented: $showSettings) {
                SwiftUIView()
            }
            .ss.bottomSafeAreaInset {
                Button {
                    
                } label: {
                    Text("12")
                        .frame(width: 100, height: 50)
                        .background {
                            Color.orange
                        }
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
