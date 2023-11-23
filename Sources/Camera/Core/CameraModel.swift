/*
 See the License.txt file for this sample’s licensing information.
 */

#if canImport(AVFoundation)
import AVFoundation
#endif
import SwiftUI
import Combine
import Photos
#if os(iOS) || targetEnvironment(macCatalyst)
@MainActor
public class CameraModel: ObservableObject {
    private var subscribers: [AnyCancellable] = []
    public let camera = CameraService()
    public let photoLibrary = PhotoLibraryService()
    
    private var backDevices: [String] = []
    private var frontDevices: [String] = []
    private var scenePhase: ScenePhase = .inactive

    public init() {
        backDevices = camera.backCaptureDevices.map(\.deviceType.deviceName)
        frontDevices = camera.frontCaptureDevices.map(\.deviceType.deviceName)
        camera.$captureEvent
            .receive(on: DispatchQueue.main)
            .sink { event in
                self.handleCaptureEvent(event)
            }
            .store(in: &subscribers)
    }
    
    @Published public var photoData: Data?
    @Published public var backDeviceIndex: Int = 0
    @Published public var cameraError: CameraError?
    @Published public var frontDeviceIndex: Int = 0
    @Published public var zoomFactor: CGFloat = 1.0
    @Published public var lastZoomFactor: CGFloat = 1.0
    @Published public var enablesLivePhoto: Bool = true
    @Published public var cameraMode: CameraMode = .none
    @Published public var hidesCameraPreview: Bool = true
    @Published public var pointOfInterest: CGPoint = .zero
    @Published public var isAvailableLivePhoto: Bool = false
    @Published public var isAvailableFlashLight: Bool = false
    @Published public var photoLibraryError: PhotoLibraryError?
    @Published public var flashMode: AVCaptureDevice.FlashMode = .off
    @Published public var focusMode: AVCaptureDevice.FocusMode? = nil
    @Published public var exposureMode: AVCaptureDevice.ExposureMode? = nil
    @Published public var cameraPermission: AVAuthorizationStatus = .notDetermined
}

extension CameraModel {
    public func switchCameraMode() {
        var index: Int
        var cameraMode: CameraMode
        switch self.cameraMode.opposite {
        case .front:
            index = frontDeviceIndex
            cameraMode = .front
        case .back:
            index = backDeviceIndex
            cameraMode = .back
        case .none:
            return
        }
        switchCameraDevice(to: index, for: cameraMode)
    }
    
    public func switchCameraDevice(to index: Int, for cameraMode: CameraMode) {
        Task {
            do {
                let cameraMode = try await camera.switchCameraDevice(to: index, for: cameraMode)
                await MainActor.run {
                    updateState(cameraMode)
                }
            } catch {
                await MainActor.run {
                    self.cameraError = error as? CameraError ?? .unknownError
                }
            }
        }
    }
    
    public func toggleLivePhoto() {
        if isAvailableLivePhoto {
            enablesLivePhoto.toggle()
        }
    }
    
    public func switchFlashMode() {
        if isAvailableFlashLight {
            switch flashMode {
            case .off: flashMode = .auto
            case .auto: flashMode = .on
            case .on: flashMode = .off
            @unknown default:
                flashMode = .off
            }
        }
    }
    
    public func switchFocusMode() {
        Task {
            let newFocusMode: AVCaptureDevice.FocusMode
            let modes: [AVCaptureDevice.FocusMode] = [.autoFocus, .continuousAutoFocus, .locked].filter {
                if $0 == focusMode {
                    return false
                }
                return camera.isFocusModeSupported($0)
            }
            if modes.isEmpty {
                await MainActor.run {
                    cameraError = .unknownError
                }
                return
            }
            switch focusMode {
            case .autoFocus:
                newFocusMode = modes.contains(.continuousAutoFocus) ? .continuousAutoFocus : .locked
            case .continuousAutoFocus:
                newFocusMode = modes.contains(.locked) ? .locked : .autoFocus
            case .locked:
                newFocusMode = modes.contains(.autoFocus) ? .autoFocus : .continuousAutoFocus
            default:
                return
            }
            do {
                try await camera.switchFocusMode(to: newFocusMode)
                await MainActor.run {
                    focusMode = newFocusMode
                }
            } catch {
                await MainActor.run {
                    cameraError = error as? CameraError ?? .unknownError
                }
            }
        }
    }
    
    public func switchExposureMode() {
        Task {
            let newExposureMode: AVCaptureDevice.ExposureMode
            let modes: [AVCaptureDevice.ExposureMode] = [.autoExpose, .continuousAutoExposure, .locked].filter {
                if $0 == exposureMode {
                    return false
                }
                return camera.isExposureModeSupported($0)
            }
            if modes.isEmpty {
                await MainActor.run {
                    cameraError = .unknownError
                }
                return
            }
            switch exposureMode {
            case .autoExpose:
                newExposureMode = modes.contains(.continuousAutoExposure) ? .continuousAutoExposure : .locked
            case .continuousAutoExposure:
                newExposureMode = modes.contains(.locked) ? .locked : .autoExpose
            case .locked:
                newExposureMode = modes.contains(.autoExpose) ? .autoExpose : .continuousAutoExposure
            default:
                return
            }
            do {
                try await camera.switchExposureMode(to: newExposureMode)
                await MainActor.run {
                    exposureMode = newExposureMode
                }
            } catch {
                await MainActor.run {
                    cameraError = error as? CameraError ?? .unknownError
                }
            }
        }
    }
    
    public func changePointOfInterest(to point: CGPoint, in frame: CGRect) {
        Task {
            do {
                await MainActor.run {
                    pointOfInterest = .zero
                }
                let offset: CGFloat = 60
                let x = max(offset, min(point.x, frame.maxX - offset))
                let y = max(offset, min(point.y, frame.maxY - offset))
                let point = CGPoint(x: x, y: y)
                await MainActor.run {
                    withAnimation {
                        pointOfInterest = point
                    }
                }
                try await camera.changePointOfInterest(to: point)
            } catch {
                await MainActor.run {
                    cameraError = error as? CameraError ?? .unknownError
                }
            }
        }
    }
    
    public func changeZoomFactor() {
        Task {
            do {
                try await camera.changeZoomFactor(to: zoomFactor)
            } catch {
                await MainActor.run {
                    cameraError = error as? CameraError ?? .unknownError
                }
            }
        }
    }
    
    public func capturePhoto() {
        camera.capturePhoto(enablesLivePhoto: enablesLivePhoto, flashMode: flashMode)
    }
}

extension CameraModel {
    public func hideCameraPreview(_ value: Bool) {
        withAnimation {
            hidesCameraPreview = value
        }
    }
    
    @MainActor
    func updateState(_ cameraMode: CameraMode) {
        withAnimation {
            self.pointOfInterest = .zero
        }
        self.cameraMode = cameraMode
        self.isAvailableFlashLight = camera.isAvailableFlashLight
        self.focusMode = camera.captureDevice?.focusMode
        self.exposureMode = camera.captureDevice?.exposureMode
        self.zoomFactor = camera.captureDevice?.videoZoomFactor ?? .zero
        self.lastZoomFactor = 1.0
    }
}

extension CameraModel {
    public func onChangeScenePhase(to scenePhase: ScenePhase) {
        onChangeScenePhaseForCamera(to: scenePhase)
        onChangeScenePhaseForPhotoLibrary(to: scenePhase)
        self.scenePhase = scenePhase
    }
    
    private func onChangeScenePhaseForCamera(to scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            let isRunning = camera.captureSession.isRunning
            camera.startSession()
            Task {
                try? await Task.sleep(nanoseconds: isRunning ? 400_000_000 : 600_000_000)
                await MainActor.run {
                    hideCameraPreview(false)
                }
            }
            guard cameraError == .cameraDenied else { return }
            Task {
                await checkCameraPermission()
            }
        case .background:
            camera.stopSession()
            hideCameraPreview(true)
        case .inactive:
            if self.scenePhase == .active {
                camera.stopSession()
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await MainActor.run {
                        hideCameraPreview(true)
                    }
                }
            } else {
                camera.startSession()
            }
        default:
            break
        }
    }
    
    private func onChangeScenePhaseForPhotoLibrary(to scenePhase: ScenePhase) {
        switch scenePhase {
        case .active:
            Task {
                await checkPhotoLibraryPermission()
            }
        default:
            break
        }
    }
}

extension CameraModel {
    public func checkCameraPermission() async {
        let status = camera.cameraPermissionStatus
        await MainActor.run {
            cameraPermission = status
        }
        switch status {
        case .notDetermined:
            _ = await camera.requestCameraPermission()
            await checkCameraPermission()
        case .restricted, .denied:
            await MainActor.run {
                cameraError = .cameraDenied
            }
        case .authorized:
            Task {
                do {
                    let cameraMode = try await camera.configureSession()
                    await MainActor.run {
                        updateState(cameraMode)
                    }
                } catch {
                    await MainActor.run {
                        self.cameraError = error as? CameraError ?? .unknownError
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    public func checkPhotoLibraryPermission() async {
        let status = photoLibrary.photoLibraryPermissionStatus
        switch status {
        case .notDetermined:
            _ = await photoLibrary.requestPhotoLibraryPermission()
            await checkPhotoLibraryPermission()
        case .restricted, .denied, .limited:
            await MainActor.run {
                photoLibraryError = .photoLibraryDenied
            }
        default: break
        }
    }
}

extension CameraModel {
    private func handleCaptureEvent(_ event: CaptureEvent?) {
        guard let event = event else { return }
        switch event {

        case let .photo(photo):
             
            photoData = photo

        case .end:

            if let photo = photoData {
                Task {
                    do {
                        try await photoLibrary.savePhoto(for: photo)
                    } catch {
                        await MainActor.run {
                            photoLibraryError = error as? PhotoLibraryError ?? .unknownError
                        }
                    }
                }
            }

        case let .error(error):
            cameraError = error as? CameraError ?? .unknownError
        }
    }
}

public enum CaptureEvent {
    case photo(Data?)
    case end
    case error(Error)
}

public extension AVCaptureDevice.DeviceType {
    var deviceName: String {
        switch self {
        case .builtInTrueDepthCamera:
            return "True Depth"
        case .builtInDualCamera:
            return "Dual"
        case .builtInDualWideCamera:
            return "Dual Wide"
        case .builtInTripleCamera:
            return "Triple"
        case .builtInWideAngleCamera:
            return "Wide Angle"
        case .builtInUltraWideCamera:
            return "Ultra Wide"
            //        case .builtInLiDARDepthCamera:
            //            return "LiDAR Depth"
        case .builtInTelephotoCamera:
            return "Telephoto"
        default:
            return "Unknown"
        }
    }
}
#endif
