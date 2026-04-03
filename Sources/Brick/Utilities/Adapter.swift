//
//  Adapter.swift
//  Brick_SwiftUI
//
//  Created by iOS on 9/18/24.
//  UI适配器 - 用于屏幕尺寸适配和缩放计算 / UI Adapter for screen size adaptation and scaling calculation
//  https://github.com/lixiang1994/UIAdapter
//

import SwiftUI
#if os(iOS)
import UIKit
/// UI适配器屏幕包装器 / UI Adapter screen wrapper
/// 用于包装基础类型以提供屏幕尺寸适配功能 / Used to wrap base types for screen size adaptation
@MainActor
public class UIAdapterScreenWrapper<Base> {
    
    let base: Screen
    
    /// 适配后的值 / The adapted value
    public private(set) var value: Base
    
    init(_ value: Base) {
        self.base = .main
        self.value = value
    }
    
    init(_ value: Base, _ screen: UIScreen) {
        self.base = .init(screen)
        self.value = value
    }
}

/// UI适配器屏幕兼容协议 / UI Adapter screen compatible protocol
/// 实现此协议的类型可以获得屏幕适配能力 / Types implementing this protocol gain screen adaptation capability
public protocol UIAdapterScreenCompatible {
    associatedtype ScreenCompatibleType
    var screen: ScreenCompatibleType { get }
    
    func screen(_: UIScreen) -> ScreenCompatibleType
}
/// UI适配器屏幕兼容协议扩展 / UI Adapter screen compatible protocol extension
@MainActor
extension UIAdapterScreenCompatible {
    
    /// 默认主屏幕适配器 / Default main screen adapter
    public var screen: UIAdapterScreenWrapper<Self> {
        get { return UIAdapterScreenWrapper(self) }
    }
    
    /// 指定屏幕适配器 / Specified screen adapter
    public func screen(_ screen: UIScreen) -> UIAdapterScreenWrapper<Self> {
        return UIAdapterScreenWrapper(self, screen)
    }
}
@MainActor
extension UIAdapterScreenWrapper {
    
    public typealias Screen = UIAdapter.Screen
    
    // MARK: - Width / 宽度适配
    
    /// 根据屏幕宽度范围适配值 / Adapt value based on screen width range (exclusive)
    public func width(_ range: Range<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕宽度范围适配值 / Adapt value based on screen width range (inclusive)
    public func width(_ range: ClosedRange<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕宽度范围适配值 / Adapt value based on screen width range (from)
    public func width(_ range: PartialRangeFrom<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕宽度范围适配值 / Adapt value based on screen width range (up to)
    public func width(_ range: PartialRangeUpTo<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕宽度范围适配值 / Adapt value based on screen width range (through)
    public func width(_ range: PartialRangeThrough<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    
    /// 宽度大于指定值时适配 / Adapt when width is greater than base
    public func width(greaterThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 > base }, is: value, zoomed: zoomed ?? value)
    }
    /// 宽度小于指定值时适配 / Adapt when width is less than base
    public func width(lessThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 < base }, is: value, zoomed: zoomed ?? value)
    }
    /// 宽度等于指定值时适配 / Adapt when width is equal to base
    public func width(equalTo base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return width({ $0 == base }, is: value, zoomed: zoomed ?? value)
    }
    private func width(_ matching: (CGFloat) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(base.size.width) {
            self.value = base.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    // MARK: - Height / 高度适配
    
    /// 根据屏幕高度范围适配值 / Adapt value based on screen height range (exclusive)
    public func height(_ range: Range<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕高度范围适配值 / Adapt value based on screen height range (inclusive)
    public func height(_ range: ClosedRange<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕高度范围适配值 / Adapt value based on screen height range (from)
    public func height(_ range: PartialRangeFrom<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕高度范围适配值 / Adapt value based on screen height range (up to)
    public func height(_ range: PartialRangeUpTo<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕高度范围适配值 / Adapt value based on screen height range (through)
    public func height(_ range: PartialRangeThrough<CGFloat>, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ range.contains($0) }, is: value, zoomed: zoomed ?? value)
    }
    
    /// 高度大于指定值时适配 / Adapt when height is greater than base
    public func height(greaterThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 > base }, is: value, zoomed: zoomed ?? value)
    }
    /// 高度小于指定值时适配 / Adapt when height is less than base
    public func height(lessThan base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 < base }, is: value, zoomed: zoomed ?? value)
    }
    /// 高度等于指定值时适配 / Adapt when height is equal to base
    public func height(equalTo base: CGFloat, is value: Base, zoomed: Base? = nil) -> Self {
        return height({ $0 == base }, is: value, zoomed: zoomed ?? value)
    }
    private func height(_ matching: (CGFloat) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(base.size.height) {
            self.value = base.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    // MARK: - Inch / 英寸尺寸适配
    
    /// 根据屏幕英寸尺寸范围适配值 / Adapt value based on screen inch range (exclusive)
    public func inch(_ range: Range<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕英寸尺寸范围适配值 / Adapt value based on screen inch range (inclusive)
    public func inch(_ range: ClosedRange<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕英寸尺寸范围适配值 / Adapt value based on screen inch range (from)
    public func inch(_ range: PartialRangeFrom<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕英寸尺寸范围适配值 / Adapt value based on screen inch range (up to)
    public func inch(_ range: PartialRangeUpTo<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕英寸尺寸范围适配值 / Adapt value based on screen inch range (through)
    public func inch(_ range: PartialRangeThrough<Double>, is value: Base, zoomed: Base? = nil) -> Self {
        return inch({ range.contains($0.rawValue) }, is: value, zoomed: zoomed ?? value)
    }
    private func inch(_ matching: (Screen.Inch) -> Bool, is value: Base, zoomed: Base) -> Self {
        if matching(base.inch) {
            self.value = base.isZoomedMode ? zoomed : value
        }
        return self
    }
    
    /// 根据屏幕英寸尺寸适配值 / Adapt value based on screen inch types
    public func inch(_ types: Screen.Inch..., is value: Base, zoomed: Base? = nil) -> Self {
        return inch(types, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕英寸尺寸列表适配值 / Adapt value based on screen inch type list
    public func inch(_ types: [Screen.Inch], is value: Base, zoomed: Base? = nil) -> Self {
        for type in types where base.inch == type {
            self.value = base.isZoomedMode ? zoomed ?? value : value
        }
        return self
    }
    
    // MARK: - Level / 屏幕级别适配
    
    /// 根据屏幕级别适配值 / Adapt value based on screen level types
    public func level(_ types: Screen.Level..., is value: Base, zoomed: Base? = nil) -> Self {
        return level(types, is: value, zoomed: zoomed ?? value)
    }
    /// 根据屏幕级别列表适配值 / Adapt value based on screen level list
    public func level(_ types: [Screen.Level], is value: Base, zoomed: Base? = nil) -> Self {
        for type in types where base.level == type {
            self.value = base.isZoomedMode ? zoomed ?? value : value
        }
        return self
    }
}
@MainActor
extension UIAdapter {
    
    /// 屏幕信息类 / Screen information class
    /// 提供屏幕尺寸、缩放比例等信息 / Provides screen size, scale ratio and other information
    public class Screen {
        
        let base: UIScreen
        
        init(_ base: UIScreen) {
            self.base = base
        }
        
        /// 屏幕尺寸 (点) / Screen size in points
        @MainActor
        public var size: CGSize {
            base.bounds.size
        }
        
        /// 屏幕原生尺寸 (像素) / Screen native size in pixels
        @MainActor
        public var nativeSize: CGSize {
            base.nativeBounds.size
        }
        
        /// 屏幕缩放比例 / Screen scale factor
        @MainActor
        public var scale: CGFloat {
            base.scale
        }
        
        /// 屏幕原生缩放比例 / Screen native scale factor
        @MainActor
        public var nativeScale: CGFloat {
            base.nativeScale
        }
        
        /// 是否为显示缩放模式 / Whether in display zoom mode
        @MainActor
        public var isZoomedMode: Bool {
            guard !UIDevice.iPhonePlus else { return size.width == 375 }
            guard !UIDevice.iPhoneMini else { return size.width == 320 }
            return scale != nativeScale
        }
        
        /// 真实宽高比 例如: iPhone 16 Pro (201:437) / Actual aspect ratio e.g. iPhone 16 Pro (201:437)
        @MainActor
        public var aspectRatio: String {
            if
                let cache = _aspectRatio,
                cache.0 == nativeSize {
                return cache.1
                
            } else {
                let result = base.aspectRatio
                _aspectRatio = (nativeSize, result)
                return result
            }
        }
        private var _aspectRatio: (CGSize, String)?
        
        /// 标准宽高比 例如: iPhone 16 Pro (9:19.5) / Standard aspect ratio e.g. iPhone 16 Pro (9:19.5)
        @MainActor
        public var standardAspectRatio: String {
            if
                let cache = _standardAspectRatio,
                cache.0 == nativeSize {
                return cache.1
                
            } else {
                let result = base.standardAspectRatio
                _standardAspectRatio = (nativeSize, result)
                return result
            }
        }
        private var _standardAspectRatio: (CGSize, String)?
    }
}
@MainActor
extension UIAdapter.Screen {
    
    /// 主屏幕 / Main screen
    public static let main = UIAdapter.Screen(.main)
}

@MainActor
extension UIAdapter.Screen {
    
    /// 屏幕英寸尺寸枚举 / Screen inch size enumeration
    public enum Inch: Double {
        case unknown = -1    /// 未知尺寸 / Unknown size
        case _3_5 = 3.5      /// 3.5英寸 / 3.5 inch
        case _4_0 = 4.0      /// 4.0英寸 / 4.0 inch
        case _4_7 = 4.7      /// 4.7英寸 / 4.7 inch
        case _5_4 = 5.4      /// 5.4英寸 / 5.4 inch
        case _5_5 = 5.5      /// 5.5英寸 / 5.5 inch
        case _5_8 = 5.8      /// 5.8英寸 / 5.8 inch
        case _6_1 = 6.1      /// 6.1英寸 / 6.1 inch
        case _6_3 = 6.3      /// 6.3英寸 / 6.3 inch
        case _6_5 = 6.5      /// 6.5英寸 / 6.5 inch
        case _6_7 = 6.7      /// 6.7英寸 / 6.7 inch
        case _6_9 = 6.9      /// 6.9英寸 / 6.9 inch
    }

    /// 获取当前屏幕的英寸尺寸 / Get current screen's inch size
    public var inch: Inch {
        switch (nativeSize.width / scale, nativeSize.height / scale, scale) {
        case (320, 480, 2):
            return ._3_5
            
        case (320, 568, 2):
            return ._4_0
            
        case (375, 667, 2):
            return ._4_7
            
        case (360, 780, 3) where UIDevice.iPhoneMini, (375, 812, 3) where UIDevice.iPhoneMini:
            return ._5_4
            
        case (360, 640, 3) where UIDevice.iPhonePlus, (414, 736, 3) where UIDevice.iPhonePlus:
            return ._5_5
        
        case (375, 812, 3):
            return ._5_8
            
        case (414, 896, 2), (390, 844, 3), (393, 852, 3):
            return ._6_1
            
        case (402, 874, 3):
            return ._6_3

        case (414, 896, 3):
            return ._6_5
            
        case (428, 926, 3), (430, 932, 3):
            return ._6_7
            
        case (440, 956, 3):
            return ._6_9
            
        default:
            return .unknown
        }
    }
    
    /// 屏幕级别枚举 / Screen level enumeration
    public enum Level: Int {
        case unknown = -1     /// 未知级别 / Unknown level
        case compact = 0     /// 3:2 紧凑型 / Compact (3:2)
        case regular = 1     /// 16:9 标准型 / Regular (16:9)
        case full = 2         /// 19.5:9 全面屏 / Full (19.5:9)
        
        /// 是否为紧凑型 / Whether is compact
        public var isCompact: Bool {
            self == .compact
        }
        
        /// 是否为标准型 / Whether is regular
        public var isRegular: Bool {
            self == .regular
        }
        
        /// 是否为全面屏 / Whether is full screen
        public var isFull: Bool {
            self == .full
        }
    }
    
    /// 获取当前屏幕的级别 / Get current screen's level
    public var level: Level {
        switch standardAspectRatio {
        case "3:4", "4:3":
            return .compact
            
        case "9:16", "16:9":
            return .regular
        
        case "9:19.5", "19.5:9":
            return .full
            
        default:
            return .unknown
        }
    }
}

extension Int: @preconcurrency UIAdapterScreenCompatible {}
extension Bool: @preconcurrency UIAdapterScreenCompatible {}
extension Float: @preconcurrency UIAdapterScreenCompatible {}
extension Double: @preconcurrency UIAdapterScreenCompatible {}
extension String: @preconcurrency UIAdapterScreenCompatible {}
extension CGRect: @preconcurrency UIAdapterScreenCompatible {}
extension CGSize: @preconcurrency UIAdapterScreenCompatible {}
extension CGFloat: @preconcurrency UIAdapterScreenCompatible {}
extension CGPoint: @preconcurrency UIAdapterScreenCompatible {}
extension UIEdgeInsets: @preconcurrency UIAdapterScreenCompatible {}


fileprivate extension UIDevice {
    
    /// 是否使用了降采样 / Whether downsampling is used
    static var isUsingDownsampling: Bool {
        return iPhoneMini || iPhonePlus
    }
    
    /// 是否为 iPhone Mini 设备 / Whether is iPhone Mini device
    static var iPhoneMini: Bool {
        let temp = ["iPhone13,1", "iPhone14,4"]
        
        switch identifier {
        case "iPhone13,1", "iPhone14,4":
            return true
            
        case "i386", "x86_64", "arm64":
            return temp.contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")
            
        default:
            return false
        }
    }
    
    /// 是否为 iPhone Plus 设备 / Whether is iPhone Plus device
    static var iPhonePlus: Bool {
        let temp = [
            "iPhone7,1",
            "iPhone8,2",
            "iPhone9,2",
            "iPhone9,4",
            "iPhone10,2",
            "iPhone10,5"
        ]
        
        switch identifier {
        case
            "iPhone7,1",
            "iPhone8,2",
            "iPhone9,2",
            "iPhone9,4",
            "iPhone10,2",
            "iPhone10,5":
            return true
            
        case "i386", "x86_64", "arm64":
            return temp.contains(ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "")
            
        default:
            return false
        }
    }
    
    private static let identifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    } ()
}

extension UIScreen {
    
    /// 真实宽高比 例如: iPhone 16 Pro (201:437) / Actual aspect ratio e.g. iPhone 16 Pro (201:437)
    var aspectRatio: String {
        let (ratioWidth, ratioHeight) = calculateAspectRatio(
            width: nativeBounds.width,
            height: nativeBounds.height
        )
        return "\(ratioWidth):\(ratioHeight)"
    }
    
    /// 标准宽高比 例如: iPhone 16 Pro (9:19.5) / Standard aspect ratio e.g. iPhone 16 Pro (9:19.5)
    var standardAspectRatio: String {
        return getStandardAspectRatio(
            width: nativeBounds.width,
            height: nativeBounds.height
        )
    }
    
    /// 计算宽高比 / Calculate aspect ratio
    private func calculateAspectRatio(width: CGFloat, height: CGFloat) -> (Int, Int) {
        func gcd(_ a: Int, _ b: Int) -> Int {
            var a = a
            var b = b
            while b != 0 {
                let temp = b
                b = a % b
                a = temp
            }
            return a
        }
        
        let precision: CGFloat = 1000
        let widthInt = Int(width * precision)
        let heightInt = Int(height * precision)
        
        let gcdValue = gcd(widthInt, heightInt)
        
        let ratioWidth = widthInt / gcdValue
        let ratioHeight = heightInt / gcdValue
        
        return (ratioWidth, ratioHeight)
    }
    
    /// 获取标准宽高比 / Get standard aspect ratio
    private func getStandardAspectRatio(width: CGFloat, height: CGFloat) -> String {
        let aspectRatio = width / height
        
        let commonRatios: [(ratio: CGFloat, description: String)] = [
            (16.0/9.0, "16:9"),
            (9.0/16.0, "9:16"),
            (4.0/3.0, "4:3"),
            (3.0/4.0, "3:4"),
            (19.5/9.0, "19.5:9"),
            (9.0/19.5, "9:19.5"),
            (2.0/1.0, "2:1"),
            (1.0/2.0, "1:2"),
            (1.0/1.0, "1:1")
        ]
        
        var closestRatio = commonRatios[0]
        var smallestDifference = abs(aspectRatio - closestRatio.ratio)
        
        for ratio in commonRatios {
            let difference = abs(aspectRatio - ratio.ratio)
            if difference < smallestDifference {
                smallestDifference = difference
                closestRatio = ratio
            }
        }
        
        return closestRatio.description
    }
}

/// UIAdapter 主枚举 / UIAdapter main enum
/// 提供屏幕适配的核心功能 / Provides core screen adaptation functionality
public enum UIAdapter {
    
    /// 缩放配置 / Zoom configuration
    public enum Zoom {
        
        /// 设置转换闭包 / Set conversion closure
        ///
        /// - Parameter conversion: 转换闭包 / Conversion closure
        @MainActor public static func set(
            conversion: @escaping ((Double) -> Double)
        ) {
            conversionClosure = conversion
        }
        
        /// 转换闭包 用于数值的等比例计算 如需自定义可重新设置 / Conversion closure for proportional calculation, can be customized
        @MainActor static var conversionClosure: ((Double) -> Double) = { (
            origin
        ) in
            guard UIDevice.current.userInterfaceIdiom == .phone else {
                return origin
            }
            
            let base = 375.0
            let screenWidth = Double(UIScreen.main.bounds.width)
            let screenHeight = Double(UIScreen.main.bounds.height)
            let width = min(screenWidth, screenHeight)
            let result = origin * (width / base)
            let scale = Double(UIScreen.main.scale)
            return (result * scale).rounded(.up) / scale
        }
    }
}

extension UIAdapter.Zoom {
    @MainActor
    static func conversion(_ value: Double) -> Double {
        return conversionClosure(value)
    }
}

/// 缩放计算协议 / Zoom calculation protocol
/// 实现此协议的类型可以进行缩放计算 / Types implementing this protocol can perform zoom calculation
public protocol UIAdapterZoomCalculationable {
    
    /// 缩放计算 / Zoom calculation
    ///
    /// - Returns: 缩放后的值 / Scaled value
    func zoom() -> Self
}

// MARK: - 扩展支持缩放计算的类型 / Extensions for types supporting zoom calculation

extension Double: @preconcurrency UIAdapterZoomCalculationable {
    /// Double 类型的缩放计算 / Zoom calculation for Double type
    @MainActor
    public func zoom() -> Double {
        return UIAdapter.Zoom.conversion(self)
    }
}
@MainActor
extension BinaryInteger {
    
    /// 整数类型的缩放计算 / Zoom calculation for integer types
    public func zoom() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
    /// 转换为整数类型的缩放计算 / Convert to integer type with zoom
    public func zoom<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
    /// 转换为浮点类型的缩放计算 / Convert to floating point type with zoom
    public func zoom<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
}

@MainActor
extension BinaryFloatingPoint {
    
    /// 浮点类型的缩放计算 / Zoom calculation for floating point types
    public func zoom() -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.zoom()
    }
    /// 转换为整数类型的缩放计算 / Convert to integer type with zoom
    public func zoom<T>() -> T where T : BinaryInteger {
        let temp = Double("\(self)") ?? 0
        return T(temp.zoom())
    }
    /// 转换为浮点类型的缩放计算 / Convert to floating point type with zoom
    public func zoom<T>() -> T where T : BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.zoom())
    }
}
@MainActor
extension CGPoint: @preconcurrency UIAdapterZoomCalculationable {
    
    /// CGPoint 的缩放计算 / Zoom calculation for CGPoint
    public func zoom() -> CGPoint {
        return CGPoint(x: x.zoom(), y: y.zoom())
    }
}
@MainActor
extension CGSize: @preconcurrency UIAdapterZoomCalculationable {
    
    /// CGSize 的缩放计算 / Zoom calculation for CGSize
    public func zoom() -> CGSize {
        return CGSize(width: width.zoom(), height: height.zoom())
    }
}
@MainActor
extension CGRect: @preconcurrency UIAdapterZoomCalculationable {
    
    /// CGRect 的缩放计算 / Zoom calculation for CGRect
    public func zoom() -> CGRect {
        return CGRect(origin: origin.zoom(), size: size.zoom())
    }
}
@MainActor
extension CGVector: @preconcurrency UIAdapterZoomCalculationable {
    
    /// CGVector 的缩放计算 / Zoom calculation for CGVector
    public func zoom() -> CGVector {
        return CGVector(dx: dx.zoom(), dy: dy.zoom())
    }
}
@MainActor
extension UIOffset: @preconcurrency UIAdapterZoomCalculationable {
    
    /// UIOffset 的缩放计算 / Zoom calculation for UIOffset
    public func zoom() -> UIOffset {
        return UIOffset(horizontal: horizontal.zoom(), vertical: vertical.zoom())
    }
}
@MainActor
extension UIEdgeInsets: @preconcurrency UIAdapterZoomCalculationable {
    
    /// UIEdgeInsets 的缩放计算 / Zoom calculation for UIEdgeInsets
    public func zoom() -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.zoom(),
            left: left.zoom(),
            bottom: bottom.zoom(),
            right: right.zoom()
        )
    }
}

// MARK: - 四舍五入扩展 / Rounded extensions

public extension Double {
    
    /// 指定小数位数的四舍五入 / Rounded to specified decimal places
    func rounded(_ decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(max(0, decimalPlaces)))
        return (self * divisor).rounded() / divisor
    }
}

public extension BinaryFloatingPoint {
    
    /// 指定小数位数的四舍五入 / Rounded to specified decimal places
    func rounded(_ decimalPlaces: Int) -> Double {
        let temp = Double("\(self)") ?? 0
        return temp.rounded(decimalPlaces)
    }
    
    /// 指定小数位数并转换为指定类型 / Rounded to specified decimal places and converted to specified type
    func rounded<T>(_ decimalPlaces: Int) -> T where T: BinaryFloatingPoint {
        let temp = Double("\(self)") ?? 0
        return T(temp.rounded(decimalPlaces))
    }
}

public extension CGPoint {
    
    /// 指定小数位数的四舍五入 / Rounded to specified decimal places
    func rounded(_ decimalPlaces: Int) -> CGPoint {
        return CGPoint(x: x.rounded(decimalPlaces), y: y.rounded(decimalPlaces))
    }
}

public extension CGSize {
    
    /// 指定小数位数的四舍五入 / Rounded to specified decimal places
    func rounded(_ decimalPlaces: Int) -> CGSize {
        return CGSize(width: width.rounded(decimalPlaces), height: height.rounded(decimalPlaces))
    }
}

public extension CGRect {
    
    /// 指定小数位数的四舍五入 / Rounded to specified decimal places
    func rounded(_ decimalPlaces: Int) -> CGRect {
        return CGRect(origin: origin.rounded(decimalPlaces), size: size.rounded(decimalPlaces))
    }
}

public extension UIEdgeInsets {
    
    /// 指定小数位数的四舍五入 / Rounded to specified decimal places
    func rounded(_ decimalPlaces: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: top.rounded(decimalPlaces),
            left: left.rounded(decimalPlaces),
            bottom: bottom.rounded(decimalPlaces),
            right: right.rounded(decimalPlaces)
        )
    }
}

#endif
