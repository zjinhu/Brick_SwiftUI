
#if os(iOS) || os(tvOS)
import UIKit
import Foundation
extension UICollectionViewCell {
    
    private static var configuredViewAssociatedKey: Void?
    
    fileprivate var configuredView: UIView? {
        get { objc_getAssociatedObject(self, &Self.configuredViewAssociatedKey) as? UIView }
        set { objc_setAssociatedObject(self, &Self.configuredViewAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
}

#endif
