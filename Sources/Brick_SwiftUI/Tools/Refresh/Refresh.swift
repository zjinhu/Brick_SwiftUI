//
//  Refresh.swift
//  Refresh_SwiftUI
//
//  Created by iOS on 2023/5/9.
//

import SwiftUI

public enum Refresh {}

public typealias RefreshHeader = Refresh.Header

public typealias RefreshFooter = Refresh.Footer

public typealias DefaultRefreshHeader = Refresh.DefaultHeader

public typealias DefaultRefreshFooter = Refresh.DefaultFooter

extension ScrollView {
    
    public func enableRefresh(_ enable: Bool = true) -> some View {
        modifier(Refresh.Modifier(enable: enable))
    }
}
