/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import AVFoundation
#if os(iOS) && !os(xrOS)
import UIKit
struct CameraPreviewLayer: UIViewRepresentable {
    let camera: CameraService

    func makeUIView(context: Context) -> LayerView {
        let view = LayerView()
        camera.cameraPreviewLayer.videoGravity = .resizeAspectFill
        camera.cameraPreviewLayer.frame = view.frame
        view.layer.addSublayer(camera.cameraPreviewLayer)
        return view
    }

    func updateUIView(_ uiView: LayerView, context: Context) { }
}

extension CameraPreviewLayer {
    class LayerView: UIView {
        override func layoutSubviews() {
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
