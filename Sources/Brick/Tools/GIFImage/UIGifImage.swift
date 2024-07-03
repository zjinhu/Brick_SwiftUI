import SwiftUI
import UIKit
import ImageIO
import MobileCoreServices

public struct GifImage: UIViewRepresentable {
    private let data: Data?
    private let name: String?
    private let repetitions: Int?
    private let onComplete: (() -> Void)?
    var contentMode: UIView.ContentMode = .scaleAspectFill
    public init(data: Data,
                repetitions: Int? = nil,
                onComplete: (() -> Void)? = nil) {
        self.data = data
        self.name = nil
        self.repetitions = repetitions
        self.onComplete = onComplete
    }
    
    public init(name: String,
                repetitions: Int? = nil,
                onComplete: (() -> Void)? = nil) {
        self.data = nil
        self.name = name
        self.repetitions = repetitions
        self.onComplete = onComplete
    }
    
    public func makeUIView(context: Context) -> UIGifImage {
        if let data = data {
            let view = UIGifImage(data: data, repetitions: repetitions, onComplete: onComplete)
            view.imageView.contentMode = contentMode
            return view
        } else {
            let view = UIGifImage(name: name ?? "", repetitions: repetitions, onComplete: onComplete)
            view.imageView.contentMode = contentMode
            return view
        }
    }
    
    public func updateUIView(_ uiView: UIGifImage, context: Context) {
        if let data = data {
            uiView.updateGIF(data: data, repetitions: repetitions, onComplete: onComplete)
            uiView.imageView.contentMode = contentMode
        } else {
            uiView.updateGIF(name: name ?? "", repetitions: repetitions, onComplete: onComplete)
            uiView.imageView.contentMode = contentMode
        }
    }
}

extension GifImage {
    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        var copy = self
        copy.contentMode = contentMode
        return copy
    }
}

public class UIGifImage: UIView {
    let imageView = UIImageView()
    private var repetitions: Int? = nil
    private var onComplete: (() -> Void)? = nil
    private var data: Data?
    private var name: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(name: String,
                     repetitions: Int? = nil,
                     onComplete: (() -> Void)? = nil) {
        self.init()
        self.name = name
        initView()
    }
    
    convenience init(data: Data,
                     repetitions: Int? = nil,
                     onComplete: (() -> Void)? = nil) {
        self.init()
        self.data = data
        initView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        self.addSubview(imageView)
    }
    
    func updateGIF(data: Data,
                   repetitions: Int? = nil,
                   onComplete: (() -> Void)? = nil) {
        self.repetitions = repetitions
        self.onComplete = onComplete
        updateWithImage {
            GifTool.gifImage(data: data)
        }
    }
    
    func updateGIF(name: String,
                   repetitions: Int? = nil,
                   onComplete: (() -> Void)? = nil) {
        self.repetitions = repetitions
        self.onComplete = onComplete
        updateWithImage {
            GifTool.gifImage(name: name)
        }
    }
    
    private func updateWithImage(_ getImage: @escaping () -> AnimationImages?) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let animationImages = getImage() {
                DispatchQueue.main.async {
                    CATransaction.begin()
                    CATransaction.setCompletionBlock {
                        self.onComplete?()
                    }
                    self.imageView.animationImages = animationImages.frames
                    self.imageView.animationDuration = animationImages.duration
                    self.imageView.animationRepeatCount = self.repetitions ?? Int.max
                    self.imageView.startAnimating()
                    CATransaction.commit()
                }
            } else {
                self.imageView.image = nil
            }
        }
    }
    
    private func initView(repetitions: Int? = nil,
                          onComplete: (() -> Void)? = nil) {
        self.repetitions = repetitions
        self.onComplete = onComplete
    }
}

public struct AnimationImages {
    let frames: [UIImage]
    let duration: Double
}

public class GifTool{
    public static func gifImage(data: Data) async -> AnimationImages? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                let animationImages = gifImage(data: data)
                continuation.resume(returning: animationImages)
            }
        }
    }
    
    public static func gifImage(data: Data) -> AnimationImages? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil)
        else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        let delays = (0..<count).map {
            // store in ms and truncate to compute GCD more easily
            Int(delayForImage(at: $0, source: source) * 1000)
        }
        let duration = delays.reduce(0, +)
        let gcd = delays.reduce(0, gcd)
        
        var frames = [UIImage]()
        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frame = UIImage(cgImage: cgImage)
                let frameCount = delays[i] / gcd
                
                for _ in 0..<frameCount {
                    frames.append(frame)
                }
            } else {
                return nil
            }
        }
        
        return AnimationImages(frames: frames, duration: Double(duration) / 1000.0)
    }
    
    public static func gifImage(name: String) -> AnimationImages? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return gifImage(data: data)
    }
    
    public static func gifData(name: String) -> Data? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return data
    }
    
    public static func createGIF(with images: [UIImage],
                                 frameDelay: TimeInterval = 0.1,
                                 loopCount: Int = 0) -> Data? {
        guard !images.isEmpty else { return nil }
        
        let fileProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: loopCount
            ]
        ]
        
        let frameProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime as String: frameDelay
            ]
        ]
        
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, kUTTypeGIF, images.count, nil) else { return nil }
        
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        for image in images {
            if let cgImage = image.cgImage {
                CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
            }
        }
        
        guard CGImageDestinationFinalize(destination) else { return nil }
        
        return data as Data
    }
    
    private static func gcd(_ a: Int, _ b: Int) -> Int {
        let absB = abs(b)
        let r = abs(a) % absB
        if r != 0 {
            return gcd(absB, r)
        } else {
            return absB
        }
    }
    
    private static func delayForImage(at index: Int, source: CGImageSource) -> Double {
        let defaultDelay = 1.0
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return defaultDelay
        }
        let gifProperties = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        var delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                              Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
                                         to: AnyObject.self)
        if delayWrapper.doubleValue == 0 {
            delayWrapper = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                              Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                                         to: AnyObject.self)
        }
        
        if let delay = delayWrapper as? Double,
           delay > 0 {
            return delay
        } else {
            return defaultDelay
        }
    }
}
