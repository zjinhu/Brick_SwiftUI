//
//  ShareLinkView.swift
//  Example
//
//  Created by iOS on 2023/6/12.
//

import SwiftUI
import Brick_SwiftUI
struct ShareLinkView: View {
    var body: some View {
        List{
 
            Brick.ShareLink(item: "Can I share this?") {
                Text("ShareLink")
            }
            .buttonStyle(.plain)

            Brick.ShareLink(item: "Some text to share")
            Brick.ShareLink("ShareLink", item: URL(string: "https://bing.com")!)
 
            Brick.ShareLink(item: URL(string: "https://apps.apple.com/us/app/id1631264265")!) {
                Text("share")
            }

        }

    }
}

struct ShareLinkView_Previews: PreviewProvider {
    static var previews: some View {
        ShareLinkView()
    }
}
