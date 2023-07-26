/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Brick_SwiftUI
#if os(iOS) && !os(xrOS)
public struct CameraView: View {
    @Binding var photoData: Data?
    
    public init(photoData: Binding<Data?>) {
        _photoData = photoData
    }
    
    @StateObject private var model = DataModel()
    
    private static let barHeightFactor = 0.15
    
    @Environment(\.dismiss) private var dismiss
    
    public var body: some View {
        
        GeometryReader { geometry in
            ViewfinderView(image:  $model.viewfinderImage )
                .overlay(alignment: .top) {
                    Color.black
                        .opacity(0.75)
                        .frame(height: geometry.size.height * Self.barHeightFactor)
                }
                .overlay(alignment: .bottom) {
                    buttonsView()
                        .frame(height: geometry.size.height * Self.barHeightFactor)
                        .background{
                            Color.black.opacity(0.75)
                        }
                }
                .overlay(alignment: .center)  {
                    Color.clear
                        .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                        .accessibilityElement()
                        .accessibilityLabel("View Finder")
                        .accessibilityAddTraits([.isImage])
                }
                .background{
                    Color.black
                }
        }
        .task {
            await model.camera.start()
 
        }
        .onChange(of: model.photoData) { newValue in
            if let newValue{
                photoData = newValue
                dismiss()
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 80) {
            
            Spacer()
   
            Button {
                dismiss()
            } label: {
                Label("Close Camera", systemImage: "xmark")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}
#endif
