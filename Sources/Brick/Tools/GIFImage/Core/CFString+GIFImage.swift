import Foundation
import ImageIO

extension CFString {
    var asKey: UnsafeMutableRawPointer {
        return Unmanaged.passUnretained(self).toOpaque()
    }
}
