/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation
#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit
public struct CameraPreviewLayer: UIViewRepresentable {
    let camera: CameraService

    public init(camera: CameraService) {
        self.camera = camera
    }
    
    public func makeUIView(context: Context) -> LayerView {
        let view = LayerView()
        camera.cameraPreviewLayer.videoGravity = .resizeAspectFill
        camera.cameraPreviewLayer.frame = view.frame
        view.layer.addSublayer(camera.cameraPreviewLayer)
        return view
    }

    public func updateUIView(_ uiView: LayerView, context: Context) { }
}

extension CameraPreviewLayer {
    public class LayerView: UIView {
        public override func layoutSubviews() {
            super.layoutSubviews()
            /// disable default animation of layer.
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.sublayers?.forEach({ layer in
                layer.frame = frame
            })
            CATransaction.commit()
        }
    }
}
#endif
