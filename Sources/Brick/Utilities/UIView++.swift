//
//  UIView.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2023/6/6.
//

#if os(iOS)
import UIKit

// MARK: - UIView 扩展 / UIView Extensions
extension UIView {

    /// 获取父视图控制器 / Get parent view controller
    var parentController: UIViewController? {
        if let responder = self.next as? UIViewController {
            return responder
        } else if let responder = self.next as? UIView {
            return responder.parentController
        } else {
            return nil
        }
    }

}

// MARK: - 子视图遍历 / Subview Traversal
extension UIView {
    /// 获取所有子视图 (递归) / Get all subviews (recursive)
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}
#endif

#if os(macOS)
import AppKit

// MARK: - NSView 扩展 / NSView Extensions
extension NSView {

    /// 获取父视图控制器 / Get parent view controller
    var parentController: NSViewController? {
        if let responder = self.nextResponder as? NSViewController {
            return responder
        } else if let responder = self.nextResponder as? NSView {
            return responder.parentController
        } else {
            return nil
        }
    }

}
#endif
