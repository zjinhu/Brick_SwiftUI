//
//  ContentView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 2023/5/12.
//

import SwiftUI
import Brick_SwiftUI
struct ContentView: View {

    @State private var showSheet = false

    @State private var url: URL?
    @State private var selection: URL?
    let urls = Bundle.main.quicklookUrls
    

    
    var body: some View {
        Brick.NavigationStack {
            List{
                
                NavigationLink("NavigationStack", destination: NavigationStack())
                
                NavigationLink("OpenURL", destination: OpenURLView())
                
                NavigationLink("ShareLink", destination: ShareLinkView())
                
                NavigationLink("Photo", destination: PhotoPickerView())
                
                NavigationLink("AsyncImage", destination: ImageView())
                
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Sheet")
                }
                
                
                Button {
                    url = urls.randomElement()
                } label: {
                    Text("Quicklook URL")
                }
                .quickLookPreview($url)
                
                Button {
                    selection = urls.randomElement()
                } label: {
                    Text("Quicklook Collection")
                }
                .quickLookPreview($selection, in: urls)
 
            }
            .sheet(isPresented: $showSheet) {
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


extension Bundle {
    var quicklookUrls: [URL] {
        urls(forResourcesWithExtension: "jpg", subdirectory: nil)?
            .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
        ?? []
    }
}
