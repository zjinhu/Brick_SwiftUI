//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

extension GridItem.Size {
    public static func adaptive(_ size: CGFloat) -> Self {
        .adaptive(minimum: size, maximum: size)
    }
}
