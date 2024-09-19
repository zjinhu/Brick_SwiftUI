//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/18/24.
//

import SwiftUI
#if os(iOS)
import UIKit

public struct Adapter {
    public static var share = Adapter()
    public var base: Double = 375
    fileprivate var adapterScale: Double?
}

public protocol Adapterable {
    associatedtype AdapterType
    var adapter: AdapterType { get }
}

extension Adapterable {
    func adapterScale() -> Double {
        if let scale = Adapter.share.adapterScale {
            return scale
        } else {
            let width = UIScreen.main.bounds.size.width
            let referenceWidth: Double = Adapter.share.base
            let scale = width / referenceWidth
            Adapter.share.adapterScale = scale
            return scale
        }
    }
}

extension Int: Adapterable {
    public typealias AdapterType = Int
    public var adapter: Int {
        let scale = adapterScale()
        let value = Double(self) * scale
        return Int(value)
    }
}

extension CGFloat: Adapterable {
    public typealias AdapterType = CGFloat
    public var adapter: CGFloat {
        let scale = adapterScale()
        let value = self * scale
        return value
    }
}

extension Double: Adapterable {
    public typealias AdapterType = Double
    public var adapter: Double {
        let scale = adapterScale()
        let value = self * scale
        return value
    }
}

extension Float: Adapterable {
    public typealias AdapterType = Float
    public var adapter: Float {
        let scale = adapterScale()
        let value = self * Float(scale)
        return value
    }
}

  
extension CGSize: Adapterable {
    public typealias AdapterType = CGSize
    public var adapter: CGSize {
        let scale = adapterScale()
        let width = self.width * scale
        let height = self.height * scale
        return CGSize(width: width, height: height)
    }
}

extension CGRect: Adapterable {
    public typealias AdapterType = CGRect
    public var adapter: CGRect {

        if self == UIScreen.main.bounds {
            return self
        }
        let scale = adapterScale()
        let x = origin.x * scale
        let y = origin.y * scale
        let width = size.width * scale
        let height = size.height * scale
        return CGRect(x: x, y: y, width: width, height: height)
    }
}

extension UIFont: Adapterable {
    public typealias AdapterType = UIFont
    public var adapter: UIFont {
        let scale = adapterScale()
        let pointSzie = self.pointSize * scale
        let fontDescriptor = self.fontDescriptor
        return UIFont(descriptor: fontDescriptor, size: pointSzie)
    }
}
#endif
