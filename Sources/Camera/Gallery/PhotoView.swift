//
//  PhotoView.swift
//  Capture
//
//  Created by Aye Chan on 2/22/23.
//

import SwiftUI
import BrickKit
#if os(iOS) || targetEnvironment(macCatalyst)
struct PhotoView: View {
    
    @StateObject var viewModel: PhotoViewModel
    let cameraModel: CameraModel
    
    init(assetId: String, cameraModel: CameraModel) {
        self.cameraModel = cameraModel
        let viewModel = PhotoViewModel(assetId: assetId, photoLibrary: cameraModel.photoLibrary)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center){
                if let photo = viewModel.photo {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .scaleEffect(viewModel.scale)
                        .offset(viewModel.offset)
                        .gesture(dragGesture(size: proxy.size))
                        .gesture(magnificationGesture(size: proxy.size))
                } else {
                    ProgressView()
                }
            }
            .maxWidth(.infinity)
            .maxHeight(.infinity)
            .ss.task {
                await viewModel.loadImage(targetSize: proxy.size)
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    cameraModel.photoData = viewModel.photo?.pngData()
                } label: {
                    Image(symbol: .checkmark)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    private func magnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / viewModel.lastScale
                viewModel.lastScale = value
                viewModel.scale = viewModel.scale * delta
            }
            .onEnded { _ in
                viewModel.lastScale = 1
                let range: (min: CGFloat, max: CGFloat) = (min: 1, max: 4)
                if viewModel.scale < range.min || viewModel.scale > range.max {
                    withAnimation {
                        viewModel.scale = min(range.max, max(range.min, viewModel.scale))
                    }
                }
                resetImageFrame(size: size)
            }
    }
    
    private func dragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let deltaX = value.translation.width - viewModel.lastOffset.width
                let deltaY = value.translation.height - viewModel.lastOffset.height
                viewModel.lastOffset = value.translation
                
                let newOffsetWidth = viewModel.offset.width + deltaX
                let newOffsetHeight = viewModel.offset.height + deltaY
                viewModel.offset.width = newOffsetWidth
                viewModel.offset.height = newOffsetHeight
            }
            .onEnded { value in
                viewModel.lastOffset = .zero
                resetImageFrame(size: size)
            }
    }
    
    func widthLimit(size: CGSize) -> CGFloat {
        let halfWidth = size.width / 2
        let scaledHalfWidth = halfWidth * viewModel.scale
        return halfWidth - scaledHalfWidth
    }
    
    func heightLimit(size: CGSize) -> CGFloat {
        let halfHeight = size.height / 2
        let scaledHalfHeight = halfHeight * viewModel.scale
        return halfHeight - scaledHalfHeight
    }
    
    func resetImageFrame(size: CGSize) {
        let widthLimit = widthLimit(size: size)
        if viewModel.offset.width < widthLimit {
            withAnimation {
                viewModel.offset.width = widthLimit
            }
        }
        if viewModel.offset.width > -widthLimit {
            withAnimation {
                viewModel.offset.width = -widthLimit
            }
        }
        
        let heightLimit = heightLimit(size: size)
        if viewModel.offset.height < heightLimit {
            withAnimation {
                viewModel.offset.height = heightLimit
            }
        }
        if viewModel.offset.height > -heightLimit {
            withAnimation {
                viewModel.offset.height = -heightLimit
            }
        }
    }
}
#endif
