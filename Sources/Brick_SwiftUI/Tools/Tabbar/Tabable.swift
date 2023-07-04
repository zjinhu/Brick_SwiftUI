//
//  Tabable.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI
public protocol Tabable: Hashable {
 
    var icon: Image { get }
 
    var selectedIcon: Image { get }
 
    var title: String { get }
    
    var color: Color { get }
}

public extension Tabable {
    var selectedIcon: Image {
        return self.icon
    }
}
