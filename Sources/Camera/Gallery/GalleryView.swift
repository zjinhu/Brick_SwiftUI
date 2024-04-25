//
//  GalleryView.swift
//  Capture
//
//  Created by Aye Chan on 2/21/23.
//

import Photos
import SwiftUI
import BrickKit
#if os(iOS) || targetEnvironment(macCatalyst)
struct GalleryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: GalleryViewModel
    let cameraModel: CameraModel
    
    init(cameraModel: CameraModel) {
        self.cameraModel = cameraModel
        let viewModel = GalleryViewModel(photoLibrary: cameraModel.photoLibrary)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var columns: [GridItem] = [GridItem](repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 3)
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<viewModel.results.count, id: \.self) { index in
                            let asset = viewModel.results[index]
                            NavigationLink {
                                PhotoView(assetId: asset.localIdentifier, cameraModel: cameraModel)
                            } label: {
                                ThumbnailView(assetId: asset.localIdentifier) { id, size in
                                    await viewModel.loadImage(for: id, targetSize: size)
                                }
                                .frame(height: (proxy.size.width - 5 * 3) / 3)
                                .id(asset.localIdentifier)
                            }
                        }
                    }
                }
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(symbol: .xmark)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
        .ss.task {
            await viewModel.loadAllPhotos()
        }
        .preferredColorScheme(.dark)
    }
}
#endif
