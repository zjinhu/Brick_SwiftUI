//
//  Tabable.swift
//  Example
//
//  Created by iOS on 2023/6/21.
//

import SwiftUI
public protocol Tabable: Hashable {
 
    var icon: String { get }
 
    var selectedIcon: String { get }
 
    var title: String { get }
    
    var color: Color { get }
}

public extension Tabable {
    var selectedIcon: String {
        return self.icon
    }
}
