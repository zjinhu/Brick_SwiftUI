//
//  PhotoThumbnail.swift
//  Capture
//
//  Created by Aye Chan on 2/21/23.
//

import SwiftUI
import BrickKit
#if os(iOS) || targetEnvironment(macCatalyst)

public struct ThumbnailView: View {
    @State var image: UIImage?

    let assetId: String
    let loadImage: (String, CGSize) async -> UIImage?

    public init(
        assetId: String,
        loadImage: @escaping (String, CGSize) async -> UIImage?
    ) {
        self.assetId = assetId
        self.loadImage = loadImage
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                } else {
                    Color.gray
                        .opacity(0.3)
                }
            }
            .ss.task {
                let image = await loadImage(assetId, proxy.size)
                await MainActor.run {
                    self.image = image
                }
            }
            .onDisappear {
                self.image = nil
            }
        }
    }
}
#endif
