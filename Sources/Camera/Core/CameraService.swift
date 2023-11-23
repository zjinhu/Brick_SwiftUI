/*
 See the License.txt file for this sample’s licensing information.
 */

#if canImport(AVFoundation)
import AVFoundation
#endif
import Combine
import CoreImage
import Photos
 
#if os(iOS) || targetEnvironment(macCatalyst)
import UIKit

public class CameraService: NSObject {
    public let captureSession : AVCaptureSession
    public let cameraPreviewLayer: AVCaptureVideoPreviewLayer
    private var isConfigured = false
    lazy var captureQueue: DispatchQueue = DispatchQueue(label: "photo-capture-queue", qos: .userInteractive)
    @Published var captureEvent : CaptureEvent?
    
    public override init() {
        self.captureSession = AVCaptureSession()
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        super.init()
    }

    private var allCaptureDevices: [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(deviceTypes:
                                            [
                                             .builtInTrueDepthCamera,
                                             .builtInDualCamera,
                                             .builtInDualWideCamera,
                                             .builtInTripleCamera,
                                             .builtInWideAngleCamera,
                                             .builtInUltraWideCamera,
//                                             .builtInLiDARDepthCamera,
                                             .builtInTelephotoCamera
                                            ],
                                         mediaType: .video,
                                         position: .unspecified).devices
    }
    
    var frontCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .front }
    }
    
    var backCaptureDevices: [AVCaptureDevice] {
        allCaptureDevices
            .filter { $0.position == .back }
    }
    
    public var captureDevice: AVCaptureDevice?
    public var isAvailableFlashLight: Bool { captureDevice?.isFlashAvailable ?? false }

    // MARK: - Input
    var captureInput: AVCaptureInput?
    // MARK: - Output
    var captureOutput: AVCaptureOutput?

    public var isUsingFrontCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return frontCaptureDevices.contains(captureDevice)
    }
    
    public var isUsingBackCaptureDevice: Bool {
        guard let captureDevice = captureDevice else { return false }
        return backCaptureDevices.contains(captureDevice)
    }
    
    public func isFocusModeSupported(_ focusMode: AVCaptureDevice.FocusMode) -> Bool {
        guard let captureDevice else { return false }
        return captureDevice.isFocusModeSupported(focusMode)
    }

    public func isExposureModeSupported(_ exposureMode: AVCaptureDevice.ExposureMode) -> Bool {
        guard let captureDevice else { return false }
        return captureDevice.isExposureModeSupported(exposureMode)
    }

    public var zoomFactorRange: (min: CGFloat, max: CGFloat) {
        guard let captureDevice else { return (1, 1) }
        return (captureDevice.minAvailableVideoZoomFactor, captureDevice.maxAvailableVideoZoomFactor)
    }
    
    public var flashMode: AVCaptureDevice.FlashMode = .off
    
}

public extension CameraService{
    func configureSession() async throws -> CameraMode {
        try await withCheckedThrowingContinuation { [unowned self] (continuation: CheckedContinuation<CameraMode, Error>) in
            captureQueue.async { [unowned self] in
                captureSession.sessionPreset = .photo
                if allCaptureDevices.isEmpty {
                    continuation.resume(throwing: CameraError.cameraUnavalible)
                }
                var cameraMode: CameraMode = .none
                do {
                    if !backCaptureDevices.isEmpty {
                        cameraMode = try configureCameraInput(from: backCaptureDevices, for: .back)
                    } else if !frontCaptureDevices.isEmpty {
                        cameraMode = try configureCameraInput(from: frontCaptureDevices, for: .front)
                    }
                    try configureCameraOutput()
                } catch {
                    continuation.resume(throwing: error)
                }
                updateConfiguration { [unowned self] in
                    captureSession.beginConfiguration()
                    if let captureInput {
                        captureSession.addInput(captureInput)
                    }
                    if let captureOutput {
                        captureSession.addOutput(captureOutput)
                    }
                    captureSession.commitConfiguration()
                }
                startSession()
                continuation.resume(returning: cameraMode)
            }
        }
    }

    @discardableResult
    private func configureCameraInput(from devices: [AVCaptureDevice], for cameraMode: CameraMode, at index: Int = 0) throws -> CameraMode {
        guard index < devices.count else { throw CameraError.unknownError }
        captureDevice = devices[index]
        if let captureDevice {
            try captureDevice.lockForConfiguration()
            captureDevice.videoZoomFactor = captureDevice.minAvailableVideoZoomFactor
            if captureDevice.isFocusPointOfInterestSupported {
                captureDevice.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            }
            if captureDevice.isExposurePointOfInterestSupported {
                captureDevice.exposurePointOfInterest = CGPoint(x: 0.5, y: 0.5)
            }
            captureDevice.unlockForConfiguration()
        }
        guard let captureDevice else {
            throw CameraError.unknownError
        }
        if let captureInput {
            updateConfiguration { [unowned self] in
                captureSession.beginConfiguration()
                captureSession.removeInput(captureInput)
                captureSession.commitConfiguration()
            }
        }
        let newCaptureInput = try AVCaptureDeviceInput(device: captureDevice)
        guard captureSession.canAddInput(newCaptureInput) else {
            throw CameraError.unknownError
        }
        self.captureInput = newCaptureInput
        return cameraMode
    }

    private func configureCameraOutput() throws {
        let captureOutput = AVCapturePhotoOutput()
        captureOutput.isLivePhotoAutoTrimmingEnabled = false
        captureOutput.isHighResolutionCaptureEnabled = true
        captureOutput.maxPhotoQualityPrioritization = .quality
        let captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        captureOutput.setPreparedPhotoSettingsArray([captureSettings], completionHandler: nil)
        guard captureSession.canAddOutput(captureOutput) else {
            throw CameraError.unknownError
        }
        self.captureOutput = captureOutput
    }

    private func updateConfiguration(_ execute: @escaping () -> Void) {
        isConfigured = false
        execute()
        isConfigured = true
    }
}

public extension CameraService{
    func startSession() {
        guard isConfigured && !captureSession.isRunning else { return }
        captureQueue.async { [unowned self] in
            captureSession.startRunning()
        }
    }

    func stopSession() {
        guard isConfigured && captureSession.isRunning else { return }
        captureQueue.async { [unowned self] in
            captureSession.stopRunning()
        }
    }
}

public extension CameraService{
    func capturePhoto(enablesLivePhoto: Bool = true, flashMode: AVCaptureDevice.FlashMode) {
        guard let captureOutput = captureOutput as? AVCapturePhotoOutput else { return }
        captureQueue.async { [unowned self] in
//            let captureSettings: AVCapturePhotoSettings
//            captureOutput.isLivePhotoCaptureEnabled = isAvailableLivePhoto && enablesLivePhoto
//            if captureOutput.isLivePhotoCaptureEnabled {
//                captureSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
//                if #available(iOS 16.0, *) {
//                    captureSettings.livePhotoMovieFileURL = FileManager.default.temporaryDirectory.appending(component: UUID().uuidString).appendingPathExtension("mov")
//                }
//            } else {
            let captureSettings = AVCapturePhotoSettings()
//            }
            
            if let previewPhotoPixelFormatType = captureSettings.availablePreviewPhotoPixelFormatTypes.first {
                captureSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            
            captureSettings.flashMode = flashMode
            captureSettings.photoQualityPrioritization = .speed
            captureSettings.isHighResolutionPhotoEnabled = true

            captureOutput.capturePhoto(with: captureSettings, delegate: self)
        }
    }

    func switchCameraDevice(to index: Int, for captureMode: CameraMode) async throws -> CameraMode {
        try await withCheckedThrowingContinuation {  [unowned self] (continuation: CheckedContinuation<CameraMode, Error>) in
            captureQueue.async { [unowned self] in
                var cameraMode: CameraMode = .none
                do {
                    switch captureMode {
                    case .front:
                        cameraMode = try configureCameraInput(from: frontCaptureDevices, for: captureMode, at: index)
                    case .back:
                        cameraMode = try configureCameraInput(from: backCaptureDevices, for: captureMode, at: index)
                    case .none:
                        cameraMode = .none
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
                if let captureInput {
                    updateConfiguration { [unowned self] in
                        captureSession.beginConfiguration()
                            captureSession.addInput(captureInput)
                        captureSession.commitConfiguration()
                    }
                }
                continuation.resume(returning: cameraMode)
            }
        }
    }

    func switchFocusMode(to focusMode: AVCaptureDevice.FocusMode) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            captureQueue.async { [unowned self] in
                guard let captureDevice else {
                    continuation.resume(throwing: CameraError.unknownError)
                    return
                }
                do {
                    try captureDevice.lockForConfiguration()
                    captureDevice.focusMode = focusMode
                    captureDevice.unlockForConfiguration()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }

    }

    func switchExposureMode(to exposureMode: AVCaptureDevice.ExposureMode) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            captureQueue.async { [unowned self] in
                guard let captureDevice else {
                    continuation.resume(throwing: CameraError.unknownError)
                    return
                }
                do {
                    try captureDevice.lockForConfiguration()
                    captureDevice.exposureMode = exposureMode
                    captureDevice.unlockForConfiguration()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func changePointOfInterest(to point: CGPoint) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            captureQueue.async { [unowned self] in
                let relativeX = point.x / cameraPreviewLayer.frame.size.width
                let relativeY = point.y / cameraPreviewLayer.frame.size.height
                let pointOfInterest = CGPoint(x: relativeX, y: relativeY)
                guard let captureDevice else {
                    continuation.resume(throwing: CameraError.unknownError)
                    return
                }
                do {
                    try captureDevice.lockForConfiguration()
                    if captureDevice.isFocusPointOfInterestSupported {
                        captureDevice.focusMode = captureDevice.focusMode
                        captureDevice.focusPointOfInterest = pointOfInterest
                    }
                    if captureDevice.isExposurePointOfInterestSupported {
                        captureDevice.exposureMode = captureDevice.exposureMode
                        captureDevice.exposurePointOfInterest = pointOfInterest
                    }
                    captureDevice.unlockForConfiguration()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func changeZoomFactor(to factor: CGFloat) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            captureQueue.async { [unowned self] in
                guard let captureDevice else {
                    continuation.resume(throwing: CameraError.unknownError)
                    return
                }
                do {
                    try captureDevice.lockForConfiguration()
                    captureDevice.ramp(toVideoZoomFactor: factor, withRate: 5)
                    captureDevice.unlockForConfiguration()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

public extension CameraService {
    var cameraPermissionStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestCameraPermission() async -> Bool {
        await AVCaptureDevice.requestAccess(for: .video)
    }
}

public extension CameraService {
    func triggerCaptureEvent(_ event: CaptureEvent) {
        captureQueue.async { [unowned self] in
            captureEvent = event
        }
    }
}
extension CameraService: AVCapturePhotoCaptureDelegate {

    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        let uniqueID = photo.resolvedSettings.uniqueID
        if let error {
            triggerCaptureEvent(.error(error))
            return
        }
        let photoData = photo.fileDataRepresentation()
        triggerCaptureEvent(.photo(photoData))
    }

    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        triggerCaptureEvent(.end)
    }
}

public enum CameraMode {
    case front
    case back
    case none

    public var opposite: CameraMode {
        switch self {
        case .front:
            return .back
        case .back:
            return .front
        case .none:
            return .none
        }
    }
}

public enum CameraError: LocalizedError {
    case cameraDenied
    case cameraUnavalible
    case focusModeChangeFailed
    case unknownError
}

public extension CameraError {
    var errorDescription: String? {
        switch self {
        case .cameraDenied:
            return "Camera Acess Denied"
        case .cameraUnavalible:
            return "Camera Unavailable"
        case .focusModeChangeFailed:
            return "Focus Mode Change Failed"
        case .unknownError:
            return "Unknown Error"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .cameraDenied:
            return "You need to allow the camera access to fully capture the moment around you. Go to Settings and enable the camera permission."
        case .cameraUnavalible:
            return "There is no camera avalible on your device. 🥲"
        case .focusModeChangeFailed:
            return "It failed to change focus mode. 🥲"
        case .unknownError:
            return "Oops! The unknown error occurs."
        }
    }
}
#endif
