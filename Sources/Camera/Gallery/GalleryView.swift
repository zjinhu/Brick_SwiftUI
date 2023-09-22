//
//  GalleryView.swift
//  Capture
//
//  Created by Aye Chan on 2/21/23.
//

import Photos
import SwiftUI
import BrickKit
public struct GalleryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: GalleryViewModel
    let photoLibrary: PhotoLibraryService

    public init(photoLibrary: PhotoLibraryService) {
        self.photoLibrary = photoLibrary
        let viewModel = GalleryViewModel(photoLibrary: photoLibrary)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var columns: [GridItem] = [GridItem](repeating: GridItem(.flexible(), spacing: 5, alignment: .center), count: 3)
    public var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(0..<viewModel.results.count, id: \.self) { index in
                            let asset = viewModel.results[index]
  
                            NavigationLink {
                                PhotoView(assetId: asset.localIdentifier, photoLibrary: photoLibrary)
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
