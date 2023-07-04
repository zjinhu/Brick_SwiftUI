//
//  Quicklook.swift
//  Example
//
//  Created by iOS on 2023/6/15.
//

import SwiftUI
 
import QuickLook
 
struct QuicklookView: View {
    
    @State private var url: URL?
    @State private var selection: URL?
    let urls = Bundle.main.quicklookUrls
    
    var body: some View {
        List{
            
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
    }
}
 

extension Bundle {
    var quicklookUrls: [URL] {
        urls(forResourcesWithExtension: "jpg", subdirectory: nil)?
            .sorted(by: { $0.lastPathComponent < $1.lastPathComponent })
        ?? []
    }
}
