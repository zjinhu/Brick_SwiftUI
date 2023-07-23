//
//  CarouselViewModel.swift
//  Example
//
//  Created by iOS on 2023/5/31.
//

import SwiftUI
import Combine

class CarouselViewModel<Data, ID>: ObservableObject where Data : RandomAccessCollection, ID : Hashable {

    @Binding
    private var index: Int
    
    private let _data: Data
    private let _dataId: KeyPath<Data.Element, ID>
    private let _spacing: CGFloat
    private let _headspace: CGFloat
    private let _isWrap: Bool
    private let _sidesScaling: CGFloat
    private let _autoScroll: CarouselAutoScroll
    private let _canMove: Bool
    
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         index: Binding<Int>,
         spacing: CGFloat,
         headspace: CGFloat,
         sidesScaling: CGFloat,
         isWrap: Bool,
         autoScroll: CarouselAutoScroll,
         canMove: Bool) {
        
        guard index.wrappedValue < data.count else {
            fatalError("The index should be less than the count of data ")
        }
        
        self._data = data
        self._dataId = id
        self._spacing = spacing
        self._headspace = headspace
        self._isWrap = isWrap
        self._sidesScaling = sidesScaling
        self._autoScroll = autoScroll
        self._canMove = canMove
        
        if data.count > 1 && isWrap {
            activeIndex = index.wrappedValue + 1
        } else {
            activeIndex = index.wrappedValue
        }
        
        self._index = index
    }

    @Published var activeIndex: Int = 0 {
        willSet {
            if isWrap {
                if newValue > _data.count || newValue == 0 {
                    return
                }
                index = newValue - 1
            } else {
                index = newValue
            }
        }
        didSet {
            changeOffset()
        }
    }

    @Published var dragOffset: CGFloat = .zero

    var viewSize: CGSize = .zero

    private var timing: TimeInterval = 0

    private var isTimerActive = true
    
    func setTimerActive(_ active: Bool) {
        isTimerActive = active
    }
    
}


extension CarouselViewModel where ID == Data.Element.ID, Data.Element : Identifiable {
    
    convenience init(_ data: Data,
                     index: Binding<Int>,
                     spacing: CGFloat,
                     headspace: CGFloat,
                     sidesScaling: CGFloat,
                     isWrap: Bool,
                     autoScroll: CarouselAutoScroll,
                     canMove: Bool) {
        self.init(data, id: \.id,
                  index: index,
                  spacing: spacing,
                  headspace: headspace,
                  sidesScaling: sidesScaling,
                  isWrap: isWrap,
                  autoScroll: autoScroll,
                  canMove: canMove)
    }
}


extension CarouselViewModel {
    
    var data: Data {
        guard _data.count != 0 else {
            return _data
        }
        guard _data.count > 1 else {
            return _data
        }
        guard isWrap else {
            return _data
        }
        return [_data.last!] + _data + [_data.first!] as! Data
    }
    
    var dataId: KeyPath<Data.Element, ID> {
        return _dataId
    }
    
    var spacing: CGFloat {
        return _spacing
    }
    
    var offsetAnimation: Animation? {
        guard isWrap else {
            return .spring()
        }
        return isAnimatedOffset ? .spring() : .none
    }
    
    var itemWidth: CGFloat {
        max(0, viewSize.width - defaultPadding * 2)
    }
    
    var timer: TimePublisher? {
        guard autoScroll.isActive else {
            return nil
        }
        return Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    func itemScaling(_ item: Data.Element) -> CGFloat {
        guard activeIndex < data.count else {
            return 0
        }
        let activeItem = data[activeIndex as! Data.Index]
        return activeItem[keyPath: _dataId] == item[keyPath: _dataId] ? 1 : sidesScaling
    }
}

extension CarouselViewModel {
    
    private var isWrap: Bool {
        return _data.count > 1 ? _isWrap : false
    }
    
    private var autoScroll: CarouselAutoScroll {
        guard _data.count > 1 else { return .inactive }
        guard case let .active(t) = _autoScroll else { return _autoScroll }
        return t > 0 ? _autoScroll : .defaultActive
    }
    
    private var defaultPadding: CGFloat {
        return (_headspace + spacing)
    }
    
    private var itemActualWidth: CGFloat {
        itemWidth + spacing
    }
    
    private var sidesScaling: CGFloat {
        return max(min(_sidesScaling, 1), 0)
    }

    private var isAnimatedOffset: Bool {
        get { UserDefaults.isAnimatedOffset }
        set { UserDefaults.isAnimatedOffset = newValue }
    }
}

extension CarouselViewModel {

    var offset: CGFloat {
        let activeOffset = CGFloat(activeIndex) * itemActualWidth
        return defaultPadding - activeOffset + dragOffset
    }

    private func changeOffset() {
        isAnimatedOffset = true
        guard isWrap else {
            return
        }
        
        let minimumOffset = defaultPadding
        let maxinumOffset = defaultPadding - CGFloat(data.count - 1) * itemActualWidth
        
        if offset == minimumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = self.data.count - 2
                self.isAnimatedOffset = false
            }
        } else if offset == maxinumOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = 1
                self.isAnimatedOffset = false
            }
        }
    }
}

extension CarouselViewModel {

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }
    
    private func dragChanged(_ value: DragGesture.Value) {
        guard _canMove else { return }
        
        isAnimatedOffset = true

        var offset: CGFloat = itemActualWidth
        if value.translation.width > 0 {
            offset = min(offset, value.translation.width)
        } else {
            offset = max(-offset, value.translation.width)
        }

        dragOffset = offset

        isTimerActive = false
    }
    
    private func dragEnded(_ value: DragGesture.Value) {
        guard _canMove else { return }

        dragOffset = .zero

        resetTiming()
        isTimerActive = true

        let dragThreshold: CGFloat = itemWidth / 3
        
        var activeIndex = self.activeIndex
        if value.translation.width > dragThreshold {
            activeIndex -= 1
        }
        if value.translation.width < -dragThreshold {
            activeIndex += 1
        }
        self.activeIndex = max(0, min(activeIndex, data.count - 1))
    }
}

extension CarouselViewModel {

    func receiveTimer(_ value: Timer.TimerPublisher.Output) {

        guard isTimerActive else {
            return
        }

        activeTiming()
        
        timing += 1
        if timing < autoScroll.interval {
            return
        }
        
        if activeIndex == data.count - 1 {

            activeIndex = 0
        } else {

            activeIndex += 1
        }
        resetTiming()
    }

    private func resetTiming() {
        timing = 0
    }

    private func activeTiming() {
        timing += 1
    }
}


private extension UserDefaults {

    private struct Keys {
        static let isAnimatedOffset = "isAnimatedOffset"
    }

    static var isAnimatedOffset: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.isAnimatedOffset)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.isAnimatedOffset)
        }
    }
}
