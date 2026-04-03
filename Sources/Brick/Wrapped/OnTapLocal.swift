//
//  OnTapLocal.swift
//  Brick_SwiftUI
//
//  本地点击位置获取
//  Local tap location acquisition
//  获取点击手势的坐标位置
//  Get tap gesture coordinate location
//
//  Created by 狄烨 on 2023/9/22.
//

import SwiftUI
#if os(iOS)

/// 点击位置修饰器
/// Tap location modifier
struct OnTap: ViewModifier {
    let response: (CGPoint) -> Void
    
    @State private var location: CGPoint = .zero
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                response(location)
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { location = $0.location }
            )
    }
}

/// Brick 扩展：获取点击位置
/// Brick extension: Get tap location
public extension Brick where Wrapped: View {
    /// 添加点击手势并获取位置
    /// Add tap gesture and get location
    /// - Parameter handler: 位置回调闭包 / Location callback closure
    /// - Returns: 修改后的 View / Modified View
    @MainActor func onTapGesture(_ handler: @escaping (CGPoint) -> Void) -> some View {
        wrapped.modifier(OnTap(response: handler))
    }
}
#endif
//struct ClickGesture: Gesture {
//    let count: Int
//    let coordinateSpace: CoordinateSpace
//
//    typealias Value = SimultaneousGesture<TapGesture, DragGesture>.Value
//
//    init(count: Int = 1, coordinateSpace: CoordinateSpace = .local) {
//        precondition(count > 0, "Count must be greater than or equal to 1.")
//        self.count = count
//        self.coordinateSpace = coordinateSpace
//    }
//
//    var body: SimultaneousGesture<TapGesture, DragGesture> {
//        SimultaneousGesture(
//            TapGesture(count: count),
//            DragGesture(minimumDistance: 0, coordinateSpace: coordinateSpace)
//        )
//    }
//
//    func onEnded(perform action: @escaping (CGPoint) -> Void) -> _EndedGesture<ClickGesture> {
//        self.onEnded { (value: Value) -> Void in
//            guard value.first != nil else { return }
//            guard let location = value.second?.startLocation else { return }
//            guard let endLocation = value.second?.location else { return }
//            guard ((location.x-1)...(location.x+1)).contains(endLocation.x),
//                  ((location.y-1)...(location.y+1)).contains(endLocation.y) else {
//                return
//            }
//            action(location)
//        }
//    }
//}
//
//extension View {
//    func onClickGesture(
//        count: Int,
//        coordinateSpace: CoordinateSpace = .local,
//        perform action: @escaping (CGPoint) -> Void
//    ) -> some View {
//        gesture(ClickGesture(count: count, coordinateSpace: coordinateSpace)
//            .onEnded(perform: action)
//        )
//    }
//
//    func onClickGesture(
//        count: Int,
//        perform action: @escaping (CGPoint) -> Void
//    ) -> some View {
//        onClickGesture(count: count, coordinateSpace: .local, perform: action)
//    }
//
//    func onClickGesture(
//        perform action: @escaping (CGPoint) -> Void
//    ) -> some View {
//        onClickGesture(count: 1, coordinateSpace: .local, perform: action)
//    }
//}
