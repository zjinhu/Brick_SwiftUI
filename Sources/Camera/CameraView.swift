/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import BrickKit
#if os(iOS) && !os(xrOS)
import UIKit
public struct CameraView: View {
    @Binding var photoData: Data?
    
    public init(photoData: Binding<Data?>) {
        _photoData = photoData
    }
    
    @StateObject private var cameraModel = CameraModel()
    @Environment(\.scenePhase) var scenePhase
    @State var isFocus = false
    
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        
        GeometryReader { proxy in
            cameraPreview
                .onTapGesture { point in
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
                        
                        buttonsView()
                    }
                    .padding(.bottom, Screen.safeArea.bottom + 10)
                }
                .overlay(alignment: .topLeading) {
                    Button{
                        dismiss()
                    } label: {
                        Image(symbol: .xmark)
                            .foregroundColor(Color.white)
                            .padding(10)
                    }
                    .background(.black.opacity(0.4))
                    .clipShape(Circle())
                    .padding(.horizontal, 20)
                    .padding(.top, Screen.safeArea.top)
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
    
    private func buttonsView() -> some View {
        HStack(spacing: 80) {
            
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

struct OnTap: ViewModifier {
    let response: (CGPoint) -> Void
    
    @State private var location: CGPoint = .zero
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                response(location)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { location = $0.location }
            )
    }
}

extension View {
    func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(OnTap(response: handler))
    }
}

//struct ClickGesture: Gesture {
//    let count: Int
//    let coordinateSpace: CoordinateSpace
//
//    typealias Value = SimultaneousGesture<TapGesture, DragGesture>.Value
//
//    init(count: Int = 1, coordinateSpace: CoordinateSpace = .local) {
//        precondition(count > 0, "Count must be greater than or equal to 1.")
//        self.count = count
//        self.coordinateSpace = coordinateSpace
//    }
//
//    var body: SimultaneousGesture<TapGesture, DragGesture> {
//        SimultaneousGesture(
//            TapGesture(count: count),
//            DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
//        )
//    }
//
//    func onEnded(perform action: @escaping (CGPoint) -> Void) -> _EndedGesture<ClickGesture> {
//        self.onEnded { (value: Value) -> Void in
//            guard value.first != nil else { return }
//            guard let location = value.second?.startLocation else { return }
//            guard let endLocation = value.second?.location else { return }
//            guard ((location.x-1)...(location.x+1)).contains(endLocation.x),
//                  ((location.y-1)...(location.y+1)).contains(endLocation.y) else {
//                return
//            }
//            action(location)
//        }
//    }
//}
//
//extension View {
//    func onClickGesture(
//        count: Int,
//        coordinateSpace: CoordinateSpace = .local,
//        perform action: @escaping (CGPoint) -> Void
//    ) -> some View {
//        gesture(ClickGesture(count: count, coordinateSpace: coordinateSpace)
//            .onEnded(perform: action)
//        )
//    }
//
//    func onClickGesture(
//        count: Int,
//        perform action: @escaping (CGPoint) -> Void
//    ) -> some View {
//        onClickGesture(count: count, coordinateSpace: .local, perform: action)
//    }
//
//    func onClickGesture(
//        perform action: @escaping (CGPoint) -> Void
//    ) -> some View {
//        onClickGesture(count: 1, coordinateSpace: .local, perform: action)
//    }
//}
#endif
