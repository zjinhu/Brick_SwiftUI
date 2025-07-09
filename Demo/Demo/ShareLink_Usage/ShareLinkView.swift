//
//  ShareLinkView.swift
//  Example
//
//  Created by iOS on 2023/6/12.
//

import SwiftUI
import BrickKit
#if os(iOS)
@available(iOS 16.0, *)
struct ShareLinkView: View {
    
    var body: some View {
        List{

            ShareLink(item: "Can I share this?") {
                Text("ShareLink")
            }
            .buttonStyle(.plain)

            ShareLink(item: "Some text to share")
            ShareLink("ShareLink", item: URL(string: "https://bing.com")!)
 
            ShareLink(item: URL(string: "https://apps.apple.com/us/app/id1631264265")!) {
                Text("share")
            }

        }
        .ss.tabBar(.hidden) 

    }
}
@available(iOS 16.0, *)
struct ShareLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ShareLinkView()
    }
}
#endif
