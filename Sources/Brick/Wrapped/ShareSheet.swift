//
//  SwiftUIView.swift
//  Brick_SwiftUI
//
//  Created by HU on 8/5/25.
//

import SwiftUI

public struct ShareSheetButton: View {
    
    @State private var isPresented = false
    
    private var shareSheetView: () -> ShareSheetView
    private var label: () -> AnyView
    
    public init(shareSheetView: @escaping () -> ShareSheetView, label: @escaping () -> AnyView) {
        self.shareSheetView = shareSheetView
        self.label = label
    }
    
    public var body: some View {
        Button {
            isPresented = true
        } label: {
            label()
        }
        .sheet(isPresented: $isPresented) {
            shareSheetView()
        }
    }
}

public struct ShareSheetView: UIViewControllerRepresentable {
    public typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    private var activityItems: [Any]
    private var applicationActivities: [UIActivity]? = nil
    private var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    private var callback: Callback? = nil
    
    public init(activityItems: [Any],
                applicationActivities: [UIActivity]? = nil,
                excludedActivityTypes: [UIActivity.ActivityType]? = nil,
                callback: Callback? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.callback = callback
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        
        if let sheet = controller.sheetPresentationController {
//            sheet.detents = [.medium()]  // 设置仅支持中等高度 (半屏)
//            sheet.largestUndimmedDetentIdentifier = .medium  // 禁止上拉至全屏
            sheet.detents = [.medium(), .large()] // 支持半屏和全屏
            sheet.prefersGrabberVisible = true // 显示抓手
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true // 上拉扩展
            sheet.prefersEdgeAttachedInCompactHeight = true// 紧贴屏幕底部
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true  // 根据内容宽度调整
        }
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
