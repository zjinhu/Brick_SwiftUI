//
//  CGSizeEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/9.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import Foundation

// MARK: - CGSize 扩展 / CGSize Extensions
public extension CGSize{
    /// 最大有限尺寸 / Greatest finite size
    static var greatestFiniteSize: CGSize {
        .init(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
    }
    
    /// 最小维度长度 / Minimum dimension length
    var minimumDimensionLength: CGFloat {
        min(width, height)
    }
    
    /// 最大维度长度 / Maximum dimension length
    var maximumDimensionLength: CGFloat {
        max(width, height)
    }
    
    /// 面积是否为零 / Whether area is zero
    var isAreaZero: Bool {
        minimumDimensionLength.isZero
    }
}
 
