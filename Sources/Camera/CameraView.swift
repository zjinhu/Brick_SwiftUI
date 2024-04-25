/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import BrickKit
#if os(iOS) || targetEnvironment(macCatalyst)

import UIKit
public struct CameraView: View {
    @Binding var photoData: Data?
    
    public init(photoData: Binding<Data?>) {
        _photoData = photoData
    }
    
    @StateObject private var cameraModel = CameraModel()
    @Environment(\.scenePhase) var scenePhase
    @State var isFocus = false
    @State var isPresentedGallery = false
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        
        GeometryReader { proxy in
            cameraPreview
                .ss.onTapGesture { point in
                    isFocus = true
                    cameraModel.changePointOfInterest(to: point, in: proxy.frame(in: .local))
                    Task {
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        await MainActor.run {
                            withAnimation {
                                isFocus = false
                            }
                        }
                    }
                }
                .overlay {
                    if cameraModel.pointOfInterest != .zero {
                        Rectangle()
                            .stroke(lineWidth: 1)
                            .frame(width: 80, height: 80)
                            .position(cameraModel.pointOfInterest)
                            .animation(.none, value: cameraModel.pointOfInterest)
                            .foregroundColor(.white)
                            .transition(.opacity)
                            .opacity(isFocus ? 1 : 0)
                    }
                }
                .overlay(alignment: .bottom) {
                    VStack{
                        Text("x\(cameraModel.zoomFactor * 100 / cameraModel.camera.zoomFactorRange.max, specifier: "%.1f")")
                            .font(.headline.bold())
                            .padding(.vertical, 3)
                            .padding(.horizontal, 10)
                            .background(.black.opacity(0.5))
                            .clipShape(Capsule())
                        
                        cameraBottomButtons
                    }
                    .padding(.bottom, Screen.safeArea.bottom + 10)
                }
                .overlay(alignment: .top) {
                    cameraTopButtons
                }
        }
        .ss.task {
            await cameraModel.checkPhotoLibraryPermission()
            await cameraModel.checkCameraPermission()
        }
        .onChange(of: scenePhase, perform: cameraModel.onChangeScenePhase(to:))
        .onChange(of: cameraModel.photoData) { newValue in
            if let newValue{
                photoData = newValue
                dismiss()
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .fullScreenCover(isPresented: $isPresentedGallery){
            GalleryView(cameraModel: cameraModel)
        }
        
    }
    
    @ViewBuilder
    var cameraPreview: some View {
        if cameraModel.cameraPermission == .authorized {
            GeometryReader { proxy in
                CameraPreviewLayer(camera: cameraModel.camera)
                    .onAppear {
                        cameraModel.hideCameraPreview(false)
                        cameraModel.camera.startSession()
                    }
                    .onDisappear {
                        cameraModel.hideCameraPreview(true)
                        cameraModel.camera.stopSession()
                    }
                    .overlay {
                        if cameraModel.hidesCameraPreview {
                            Color.defaultBackground
                                .transition(.opacity.animation(.default))
                        }
                    }
                    .gesture(magnificationGesture(size: proxy.size))
            }
        } else {
            Color.black
        }
    }
    
    @ViewBuilder
    var cameraTopButtons: some View {
        HStack{
            Button{
                dismiss()
            } label: {
                Image(symbol: .xmark)
                    .foregroundColor(Color.white)
                    .frame(width: 50, height: 50)
            }
            .background(.black.opacity(0.4))
            .clipShape(Circle())
            
            Spacer()
            
            Button {
                cameraModel.switchFlashMode()
            } label: {
                switch cameraModel.flashMode {
                case .auto:
                    Image(symbol: .bolt)
                        .foregroundColor(Color.white)
                        .frame(width: 50, height: 50)
                case .off:
                    Image(symbol: .boltSlash)
                        .foregroundColor(Color.white)
                        .frame(width: 50, height: 50)
                case .on:
                    Image(symbol: .bolt)
                        .foregroundColor(.yellow)
                        .frame(width: 50, height: 50)
                default:
                    EmptyView()
                }
            }
            .background(.black.opacity(0.4))
            .clipShape(Circle())
        }
        .padding(.horizontal, 20)
        .padding(.top, Screen.safeArea.top)
    }
    
    @ViewBuilder
    var cameraBottomButtons: some View {
        HStack(spacing: 80) {
            Spacer()
            Button {
                isPresentedGallery.toggle()
            } label: {
                Image(symbol: .photoOnRectangleAngled)
                    .foregroundColor(Color.white)
                    .frame(width: 50, height: 50)
            }
            .background(.black.opacity(0.4))
            .clipShape(Circle())
            
            Button {
                cameraModel.capturePhoto()
            } label: {
                
                ZStack {
                    Circle()
                        .strokeBorder(.white, lineWidth: 5)
                        .frame(width: 70, height: 70)
                    Circle()
                        .fill(.white)
                        .frame(width: 55, height: 55)
                }
                
            }
            
            Button {
                cameraModel.switchCameraMode()
            } label: {
                Image(symbol: .arrowTriangle2CirclepathCamera)
                    .foregroundColor(Color.white)
                    .frame(width: 50, height: 50)
            }
            .background(.black.opacity(0.4))
            .clipShape(Circle())
            
            Spacer()
        }
        .buttonStyle(.plain)
    }
    
    private func magnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let range = cameraModel.camera.zoomFactorRange
                let maxZoom = range.max * 5 / 100
                guard cameraModel.zoomFactor >= range.min && cameraModel.zoomFactor <= maxZoom else {
                    return
                }
                let delta = value / cameraModel.lastZoomFactor
                cameraModel.lastZoomFactor = value
                cameraModel.zoomFactor = min(maxZoom, max(range.min, cameraModel.zoomFactor * delta))
                cameraModel.changeZoomFactor()
            }
            .onEnded { _ in
                cameraModel.lastZoomFactor = 1
                cameraModel.changeZoomFactor()
            }
    }
}

#endif
