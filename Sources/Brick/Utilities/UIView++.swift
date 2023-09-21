//
//  UIView.swift
//  Brick_SwiftUI
//
//  Created by 狄烨 on 2023/6/6.
//

#if os(iOS)
import UIKit

extension UIView {

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

extension UIView {
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

extension NSView {

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
