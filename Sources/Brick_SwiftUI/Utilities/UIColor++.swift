//
//  UIColorEx.swift
//  SwiftBrick
//
//  Created by iOS on 25/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//
#if os(iOS)
import UIKit
extension UIColor {
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
    
    ///根据16进制字符串生成颜色.支持 0x 或 # 开头字符串
    convenience init(hex: String) {
        var string = ""
        if hex.lowercased().hasPrefix("0x") {
            string =  hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            string = hex.replacingOccurrences(of: "#", with: "")
        } else {
            string = hex
        }
        var int: UInt64 = 0
        
        Scanner(string: string).scanHexInt64(&int)
        let a, r, g, b: UInt64
        
        switch string.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(r: Int(r), g: Int(g), b: Int(b), a: CGFloat(a))
    }
    
    ///根据RGB生成颜色
    convenience init(r: Int, g: Int, b: Int, a: CGFloat = 1) {
        var trans = a
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: trans)
    }
}
#endif
