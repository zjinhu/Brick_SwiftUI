#if os(iOS)
import SwiftUI

public struct PageScrollView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    
    private let content: () -> ForEach<Data, ID, Content>
    private let pageOutWidth : CGFloat
    private let pagePadding : CGFloat
    
    
    public init(pageOutWidth: CGFloat,
                pagePadding: CGFloat,
                @ViewBuilder content: @escaping () -> ForEach<Data, ID, Content>) {
        self.content = content
        self.pageOutWidth = pageOutWidth
        self.pagePadding = pagePadding
    }
    
    public var body: some View {
        if #available(iOS 17.0, *) {
            Paging17ScrollView(pageOutWidth: pageOutWidth,
                               pagePadding: pagePadding,
                               content: content)
        } else {
            PagingScrollView(pageOutWidth: pageOutWidth,
                             pagePadding: pagePadding,
                             content: content)
        }
        
    }
}

#Preview {
    PageScrollView( pageOutWidth: 50,
                    pagePadding: 10){
        ForEach(0 ..< 10, id: \.self) { index in
            
            RoundedRectangle(cornerRadius: 20)
                .fill(.orange)
                .overlay {
                    Text("\(index)")
                }
                .onTapGesture {
                    print ("tap on index: \(index)")
                }
            
        }
    }
                    .frame(height: 228)
}

struct PagingScrollView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let items: [AnyView]
    @State var pageFrameWidth: CGFloat = 0
    private let pageWidth : CGFloat
    private let pagePadding : CGFloat
    private let itemCount : Int
    private let scrollDampingFactor: CGFloat = 0.66
    @State private var dragOffset : CGFloat = 0
    @State private var activePageIndex : Int = 0
    
    public init(pageOutWidth: CGFloat,
                pagePadding: CGFloat,
                @ViewBuilder content: () -> ForEach<Data, ID, Content>) {
        let views = content()
        self.items = views.data.map({ AnyView(views.content($0)) })
        let itemCount = views.data.count
        self.pageWidth = UIScreen.main.bounds.size.width - (pageOutWidth+pagePadding)*2
        self.pagePadding = pagePadding
        self.itemCount = itemCount
    }
    
    func offsetForPageIndex(_ index: Int)->CGFloat {
        return -baseTileOffset(index: index)
    }
    
    func indexPageForOffset(_ offset : CGFloat) -> Int {
        guard itemCount>0 else {
            return 0
        }
        let offset = logicalScrollOffset(trueOffset: offset)
        let floatIndex = (offset)/(pageWidth+pagePadding)
        var computedIndex = Int(round(floatIndex))
        computedIndex = max(computedIndex, 0)
        return min(computedIndex, itemCount-1)
    }
    
    func currentScrollOffset(activePageIndex: Int, dragoffset: CGFloat)->CGFloat {
        return offsetForPageIndex(activePageIndex) + dragOffset
    }
    
    func logicalScrollOffset(trueOffset: CGFloat)->CGFloat {
        return (trueOffset) * -1.0
    }
    
    private let animation = Animation.interpolatingSpring(mass: 0.1, stiffness: 20, damping: 2, initialVelocity: 0)
    
    func baseTileOffset(index: Int) -> CGFloat {
        return CGFloat(index)*(pageWidth + pagePadding)
    }
    
    var body: some View {
        
        ZStack(alignment: .center)  {
            let globalOffset = currentScrollOffset(activePageIndex: activePageIndex, dragoffset: dragOffset)
            ForEach(0..<items.count, id:\.self) { index in
                
                items[index]
                    .frame(width: pageWidth)
                    .offset(x: baseTileOffset(index: index) + globalOffset)
            }
        }
        .background(
            MeasureGeometry(space: .local, identifier: "container")
        )
        .onPreferenceChange(FrameMeasurePreferenceKey.self) {
            guard let frame = $0["container"] else { return }
            pageFrameWidth = frame.size.width
        }
        .background(Color.black.opacity(0.00001))
        .simultaneousGesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    let velocityDiff = (value.predictedEndTranslation.width - self.dragOffset)*scrollDampingFactor
                    let targetOffset = currentScrollOffset(activePageIndex: activePageIndex, dragoffset: dragOffset)
                    
                    withAnimation(animation){
                        dragOffset = 0
                        activePageIndex = indexPageForOffset(targetOffset+velocityDiff)
                    }
                }
        )
    }
}
@MainActor
struct FrameMeasurePreferenceKey: @preconcurrency PreferenceKey {
    typealias Value = [String: CGRect]
    
    static var defaultValue: Value = Value()
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { current, new in
            new
        }
    }
}

struct MeasureGeometry: View {
    let space: CoordinateSpace
    let identifier: String
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: FrameMeasurePreferenceKey.self, value: [identifier: geometry.frame(in: space)])
        }
    }
}

@available(iOS 17.0, *)
struct Paging17ScrollView<Data: RandomAccessCollection, ID: Hashable, Content: View>: View {
    private let items: [AnyView]
    private let pageOutWidth : CGFloat
    private let pagePadding : CGFloat
    private let itemCount : Int
    
    public init(pageOutWidth: CGFloat,
                pagePadding: CGFloat,
                @ViewBuilder content: () -> ForEach<Data, ID, Content>) {
        let views = content()
        self.items = views.data.map({ AnyView(views.content($0)) })
        let itemCount = views.data.count
        self.pageOutWidth = pageOutWidth
        self.pagePadding = pagePadding
        self.itemCount = itemCount
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: pagePadding) {
                ForEach(0..<items.count, id:\.self) { index in
                    items[index]
                        .containerRelativeFrame([.vertical, .horizontal])
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, pageOutWidth)
    }
}
#endif
