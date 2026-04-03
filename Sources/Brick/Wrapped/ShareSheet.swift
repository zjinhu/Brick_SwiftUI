//
//  ShareSheet.swift
//  Brick_SwiftUI
//
//  自定义分享面板组件
//  Custom share sheet component
//  - ShareSheetButton: 分享按钮 / Share button
//  - ShareSheetView: UIActivityViewController 封装 / UIActivityViewController wrapper
//
//  Created by HU on 8/5/25.
//

import SwiftUI
import UIKit

/// 分享按钮组件
/// Share button component
public struct ShareSheetButton: View {
    
    @State private var isPresented = false
    
    private var shareSheetView: () -> ShareSheetView
    private var label: () -> AnyView
    
    /// 初始化分享按钮
    /// Initialize share button
    /// - Parameters:
    ///   - shareSheetView: 分享视图构建器 / Share sheet view builder
    ///   - label: 标签视图构建器 / Label view builder
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

/// UIActivityViewController 封装，用于自定义分享面板
/// UIActivityViewController wrapper for custom share sheet
public struct ShareSheetView: UIViewControllerRepresentable {
    /// 分享完成回调 / Share completion callback
    public typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    private var activityItems: [Any]
    private var applicationActivities: [UIActivity]? = nil
    private var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    private var callback: Callback? = nil
    
    /// 初始化分享视图
    /// Initialize share view
    /// - Parameters:
    ///   - activityItems: 分享内容数组 / Activity items to share
    ///   - applicationActivities: 自定义分享活动 / Custom activities
    ///   - excludedActivityTypes: 排除的活动类型 / Excluded activity types
    ///   - callback: 完成回调 / Completion callback
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
        
        // 配置 sheet 样式 / Configure sheet style
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
