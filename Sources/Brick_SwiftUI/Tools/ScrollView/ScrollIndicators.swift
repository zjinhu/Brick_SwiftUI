import SwiftUI

@available(iOS, deprecated: 16)
@available(tvOS, deprecated: 16)
@available(macOS, deprecated: 13)
@available(watchOS, deprecated: 9)
extension Brick where Wrapped: View {

    /// Sets the visibility of scroll indicators within this view.
    ///
    /// Use this modifier to hide or show scroll indicators on scrollable
    /// content in views like a ``ScrollView``, ``List``, or ``TextEditor``.
    /// This modifier applies the prefered visibility to any
    /// scrollable content within a view hierarchy.
    ///
    ///     ScrollView {
    ///         VStack(alignment: .leading) {
    ///             ForEach(0..<100) {
    ///                 Text("Row \($0)")
    ///             }
    ///         }
    ///     }
    ///     .ss.scrollIndicators(.hidden)
    ///
    /// Use the ``Brick.ScrollIndicatorVisibility.hidden`` value to indicate that you
    /// prefer that views never show scroll indicators along a given axis.
    /// Use ``Brick.ScrollIndicatorVisibility.visible`` when you prefer that
    /// views show scroll indicators. Depending on platform conventions,
    /// visible scroll indicators might only appear while scrolling. Pass
    /// ``Brick.ScrollIndicatorVisibility.automatic`` to allow views to
    /// decide whether or not to show their indicators.
    ///
    /// - Parameters:
    ///   - visibility: The visibility to apply to scrollable views.
    ///   - axes: The axes of scrollable views that the visibility applies to.
    ///
    /// - Returns: A view with the specified scroll indicator visibility.
    public func scrollIndicators(_ visibility: Brick<Any>.ScrollIndicatorVisibility, axes: Axis.Set = [.vertical]) -> some View {
        wrapped
            .environment(\.horizontalScrollIndicatorVisibility, axes.contains(.horizontal) ? visibility : .automatic)
            .environment(\.verticalScrollIndicatorVisibility, axes.contains(.vertical) ? visibility : .automatic)
#if os(iOS)
            .sibling(forType: UIScrollView.self) { proxy in
                let scrollView = proxy.instance
                if axes.contains(.horizontal) {
                    scrollView.showsHorizontalScrollIndicator = visibility.scrollViewVisible
                    scrollView.alwaysBounceHorizontal = true
                } else {
                    scrollView.alwaysBounceHorizontal = false
                }

                if axes.contains(.vertical) {
                    scrollView.showsVerticalScrollIndicator = visibility.scrollViewVisible
                    scrollView.alwaysBounceVertical = true
                } else {
                    scrollView.alwaysBounceVertical = false
                }
            }
#endif
    }

}
