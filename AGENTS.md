# BrickKit AI Skills

## Project Overview

BrickKit is a SwiftUI APP Acceleration Development Kit that provides:
- View extensions via `Brick<Wrapped>` pattern (`view.ss.xxx`)
- Pre-built UI components for rapid development
- Core utility tools

## Directory Structure

```
Sources/Brick/
├── SwiftUI/           # SwiftUI extensions
│   ├── GridIem++     # Grid item extensions (GridItem.Size.adaptive/flexible)
│   ├── String+       # String extensions (localized, toInt, etc.)
│   ├── View+Geometry # View geometry extensions (onGeometryChange)
│   ├── Angle++       # Angle extensions (radians/degrees conversion)
│   ├── Collection+   # Collection extensions (push, pop, popTo helpers)
│   ├── ForEach++     # ForEach extensions
│   ├── Image++       # Image extensions (resize, tint, etc.)
│   ├── Label++       # Label extensions
│   ├── List++        # List extensions
│   ├── Menu++        # Menu extensions
│   ├── NavigationLink++ # NavigationLink extensions
│   ├── Section++     # Section extensions
│   ├── Shape++       # Shape extensions
│   ├── Spacer+       # Spacer extensions
│   ├── Task+         # Task extensions
│   ├── Text++        # Text extensions
│   ├── URL+          # URL extensions (scheme detection)
│   ├── View++        # General View extensions (eraseToAnyView, etc.)
│   ├── View+Background # View background extensions
│   ├── View+Conditionals # Conditional view modifiers
│   ├── View+Frame    # View frame extensions
│   ├── View+Geometry # View geometry extensions (onGeometryChange)
│   ├── View+Haptic   # View haptic feedback extensions
│   ├── View+Mask     # View mask extensions
│   └── View+Shadow   # View shadow extensions
├── Wrapped/          # View extensions via Brick<Wrapped> pattern (`view.ss.xxx`)
│   ├── ViewWrapped.swift    # Core Brick<Wrapped> + shadow/border
│   ├── Background.swift     # Background + hideListBackground/hideTextViewBackground
│   ├── Overlay.swift        # Overlay with alignment
│   ├── Geometry.swift       # onGeometryChange, visualEffect
│   ├── Alert.swift          # Alert presentation
│   ├── Badge.swift          # Badge overlay
│   ├── Border.swift         # Border modifier
│   ├── Corner.swift         # Corner radius modifier
│   ├── Mask.swift           # Mask modifier
│   ├── Hidden.swift         # Hidden view modifier
│   ├── SafeArea.swift       # Safe area insets
│   ├── BottomSafeArea.swift # Bottom safe area handling
│   ├── Alignment.swift      # Alignment helpers
│   ├── Section.swift        # Section helpers
│   ├── Submit.swift         # Submit handling
│   ├── Task.swift           # Task handling
│   ├── OnChange.swift       # onChange wrapper
│   ├── TabbarColor.swift    # TabBar color customization
│   ├── TabbarVisible.swift  # TabBar visibility control
│   ├── NavigationTitle.swift # Navigation title customization
│   ├── NavigationBarColor.swift # NavigationBar color
│   ├── CustomBackButton.swift # Custom back button
│   ├── ListSpace.swift      # List spacing
│   ├── OnTapLocal.swift     # Local tap gesture
│   ├── PushTransition.swift # Push transition animations
│   ├── ShareSheet.swift     # Share sheet presentation
│   ├── Checkmark.swift      # Checkmark view
│   ├── RequestReview.swift  # App Store review request
│   ├── AppStore.swift       # App Store helpers
│   └── ProposedViewSize.swift # Proposed view size
├── Utilities/         # Core utilities
│   ├── Brick.swift            # Core wrapper type (Brick<Wrapped>)
│   ├── BrickLog.swift         # Logging utilities
│   ├── Adapter.swift          # Responsive design adapter (screen scaling)
│   ├── Application.swift      # App info (version, build, name, bundle ID)
│   ├── CurrentLanguage.swift  # Language detection utilities
│   ├── Keyboard.swift         # Keyboard manager (show/hide, height tracking)
│   ├── Color+.swift           # SwiftUI Color extensions
│   ├── UIColor++.swift        # UIKit UIColor extensions
│   ├── UIView++.swift         # UIKit UIView extensions
│   ├── Screen++.swift         # Screen utilities (size, scale, safe area)
│   ├── CGSize++.swift         # CGSize extensions
│   ├── Image+.swift           # Image extensions
│   ├── SFSymbols/             # Type-safe SF Symbols
│   │   ├── SFSymbolName.swift # Protocol for SF Symbol names
│   │   └── SFSymbolsV1-V7.swift # SF Symbol versions (iOS 13-18)
│   └── ViewLifeCycle/         # View lifecycle hooks
│       ├── OnFirstAppear.swift    # onFirstAppear view modifier
│       ├── WillDisappear.swift    # onWillDisappear view modifier
│       └── DidDisappear.swift     # onDidDisappear view modifier
└── Tools/             # UI Components
    ├── Animation/     # Animation components (Animation+, WithAnimation+)
    ├── Blur/          # Blur effects (GlassBlurView, BlurView)
    ├── CarouselView/  # Carousel components (CarouselView, CarouselViewModel)
    ├── Date/          # Date utilities (Date+, DateFormatter, JSONEncoder/Decoder+Date)
    ├── Gestures/      # Gesture handlers (GestureButton, ScrollViewGestureButton, SwipeGesture)
    ├── Keychain/      # Keychain utilities (KeychainService, KeychainWrapper, KeychainItemAccessibility)
    ├── Language/      # Language settings (Language, LanguageSettings, LanguageView, SelectLanguageView)
    ├── List/          # List utilities (ListLoadMore, ListEmpty)
    ├── Loading/       # Loading overlays (Loading.swift + LoadingManager/)
    ├── Navigation/    # Navigation components (NavigationItem, NavigationPath+, NavigationSwipeBack)
    ├── NavigationStack/ # Navigation stack (iOS 16- compatible, Navigator, NavigationLink, NavigationPath)
    ├── OpenUrl/       # URL opening (OpenURL, Link, Safari, WebView)
    ├── Others/        # Other components (FlipView, MarqueeText, RadioButton, OtpView, ExpandText, etc.)
    ├── Page/          # Page components (PageScrollView, PageIndicator)
    ├── Picker/        # Picker components (ListPicker, ListMultiPicker, ForEachPicker, etc.)
    ├── Presentation/  # Presentation controls (Detents, DragIndicator, CornerRadius, InteractiveDismiss)
    ├── Progress/      # Progress indicators (LinearProgressBar, CircularProgressBar + Styles)
    ├── Refresh/       # Pull-to-refresh (Refresh, Header, Footer, DefaultHeader, DefaultFooter)
    ├── ScrollStack/   # Scrollable stacks (VScrollStack, HScrollStack, VScrollGrid, HScrollGrid)
    ├── ScrollView/    # ScrollView helpers (indicators, keyboard dismiss, enabled, tracking)
    ├── Segment/       # Segment picker (CustomSegmentPicker)
    ├── Shape/         # Custom shapes (Triangle, RoundedCorner)
    ├── TTextField/     # Text field component
    ├── Text/          # Text components
    ├── Toast/         # Toast notifications
    ├── UIHosting/     # UIKit integration
    └── UnderLineText/ # Underline text input
```

## Brick<Wrapped> Pattern

The core of BrickKit is the `Brick<Wrapped>` pattern that enables `view.ss.xxx` syntax for view extensions.

### Usage
```swift
import Brick

// Use via .ss property
view.ss.tabBar(.hidden)
view.ss.onChange(of: value) { newValue in }
view.ss.badge { Text("99+") }
```

### Adding New Extensions

1. Create extension in `Sources/Brick/Wrapped/`:
```swift
extension Brick where Wrapped: View {
    /// 方法描述/Method description
    /// - Parameter param: 参数描述/Parameter description
    /// - Returns: 返回描述/Return description
    public func myMethod(_ param: Type) -> some View {
        wrapped
            .someModifier()
    }
}
```

2. Also add to View extension for direct access:
```swift
public extension View {
    func myMethod(_ param: Type) -> some View {
        self.ss.myMethod(param)
    }
}
```

## SwiftUI Extensions

Extensions in `Sources/Brick/SwiftUI/` provide additional functionality for SwiftUI types.

### GridIem++
```swift
GridItem.Size.adaptive(100)
GridItem.Size.flexible(minimum: 50, maximum: 200)
```

### String+
```swift
"Hello".localized()
"123".toInt()
```

### View+Geometry
```swift
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { old, new in }
```

### Angle++
```swift
let radians = Angle.degrees(90).radians
let degrees = Angle.radians(.pi).degrees
```

### Collection+
```swift
var items = [1, 2, 3]
items.push(4)
items.pop()
items.popTo(index: 0)
```

### ForEach++
```swift
ForEach(items.indices, id: \.self) { index in
    // ...
}
```

### Image++
```swift
Image(systemName: "heart")
    .resizable()
    .aspectRatio(contentMode: .fit)
    .tinted(with: .red)
```

### Label++
```swift
Label("Title", systemImage: "star")
    .labelStyle(.titleOnly)
```

### List++
```swift
List(items) { item in
    Text(item.name)
}
.listStyle(.plain)
```

### Menu++
```swift
Menu("Actions") {
    Button("Delete", role: .destructive) { }
}
```

### NavigationLink++
```swift
NavigationLink("Detail", value: "detail")
```

### Section++
```swift
Section {
    Text("Content")
} header: {
    Text("Header")
}
```

### Shape++
```swift
Circle()
    .fill(Color.blue)
```

### Spacer+
```swift
Spacer.fixed(20)
Spacer.min
```

### Task+
```swift
Task.detached { }
```

### Text++
```swift
Text("Hello").bold().foregroundColor(.red)
```

### URL+
```swift
url.isWebURL  // Check if URL is web scheme
```

### View++
```swift
view.eraseToAnyView()
view.if(condition) { $0.padding() }
```

### View+Background
```swift
view.background(Color.red)
```

### View+Conditionals
```swift
view.if(isVisible) { $0.padding() }
view.unless(isHidden) { $0.opacity(0.5) }
```

### View+Frame
```swift
view.frame(width: 100, height: 50)
```

### View+Haptic
```swift
view.onTapGesture {
    HapticFeedback.impact(.light)
}
```

### View+Mask
```swift
view.mask(LinearGradient(...))
```

### View+Shadow
```swift
view.shadow(color: .black, radius: 5, x: 0, y: 2)
```

## Utilities

Core utility tools in `Sources/Brick/Utilities/`:

### Core
- `Brick.swift` - Core wrapper type (`Brick<Wrapped>`)
- `BrickLog.swift` - Logging utilities

### SFSymbols (Type-safe SF Symbols)
- `SFSymbolName.swift` - Protocol for SF Symbol names
- `SFSymbolsV1.swift` ~ `SFSymbolsV7.swift` - SF Symbol versions (iOS 13-18)

### Color Extensions
- `Color+.swift` - SwiftUI Color extensions
- `UIColor++.swift` - UIKit UIColor extensions

### View Extensions
- `UIView++.swift` - UIKit UIView extensions
- `Screen++.swift` - Screen utilities (size, scale, safe area)
- `CGSize++.swift` - CGSize extensions
- `Image+.swift` - Image extensions

### Keyboard
- `Keyboard.swift` - Keyboard manager (show/hide, height tracking)

### Adapter
- `Adapter.swift` - Responsive design adapter (screen width/height scaling)

### Language
- `CurrentLanguage.swift` - Language detection utilities

### Application
- `Application.swift` - App info (version, build, name, bundle ID)

### ViewLifeCycle
- `OnFirstAppear.swift` - onFirstAppear view modifier
- `WillDisappear.swift` - onWillDisappear view modifier
- `DidDisappear.swift` - onDidDisappear view modifier

### Usage Examples

```swift
// SFSymbols - Type-safe SF Symbols
Image(symbol: .person)
Image(symbol: .heart)
Image(symbol: .star)

// Color extensions
Color.random
Color.hex("#FF0000")
Color.gradient(start: .red, end: .blue)

// Screen utilities
Screen.realWidth
Screen.realHeight
Screen.scale
Screen.safeAreaTop
Screen.safeAreaBottom

// CGSize extensions
CGSize(width: 100, height: 100).scaled(by: 2)

// Keyboard manager
Keyboard.shared.height  // Current keyboard height
Keyboard.shared.show()
Keyboard.shared.hide()

// Adapter - Responsive design
Adapter.width(100)   // Scale width based on screen
Adapter.height(100)  // Scale height based on screen
Adapter.font(16)     // Scale font size

// Application info
Application.version      // App version
Application.build        // App build number
Application.name         // App name
Application.bundleID     // Bundle identifier

// View lifecycle
view.onFirstAppear { }
view.onWillDisappear { }
view.onDidDisappear { }
```

## Wrapped Usage

View extensions via `Brick<Wrapped>` pattern (`view.ss.xxx`):

```swift
// Shadow & Border (ViewWrapped)
view.ss.shadow(color: .black, x: 0, y: 2, blur: 10)
view.ss.border { RoundedRectangle(cornerRadius: 8) }
    .border(color: .gray, width: 1, cornerRadius: 8)

// Background
view.ss.background { Color.red }
view.ss.background(alignment: .leading) { Star(color: .red) }
view.ss.hideListBackground()    // Hide List background
view.ss.hideTextViewBackground() // Hide TextView background

// Overlay
view.ss.overlay { Color.blue.opacity(0.5) }
view.ss.overlay(alignment: .topLeading) { Badge() }

// Geometry
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { newSize in
    print("Size changed: \(newSize)")
}
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { old, new in
    print("Size: \(old) -> \(new)")
}
view.ss.visualEffect { view, proxy in
    view.blur(radius: proxy.size.width / 100)
}

// Alert
view.ss.alert(isPresented: $showAlert) {
    Alert(title: Text("Title"), message: Text("Message"))
}

// Badge
view.ss.badge { Text("99+").foregroundColor(.white) }

// Corner
view.ss.corner(10)

// Mask
view.ss.mask { LinearGradient(...) }

// Hidden
view.ss.hidden(isHidden)

// Safe Area
view.ss.safeArea(.top) { Color.red }
view.ss.safeArea(.bottom) { Color.blue }
view.ss.bottomSafeArea { Color.black }

// Alignment
view.ss.alignment(.center)

// Section
view.ss.sectionStyle(.grouped)

// Submit
view.ss.onSubmit { }

// Task
view.ss.task { }

// OnChange
view.ss.onChange(of: value) { newValue in }
view.ss.onChange(of: value) { oldValue, newValue in }

// TabBar
view.ss.tabBar(.hidden)
view.ss.tabBarColor(.white)

// Navigation
view.ss.navigationTitle("Title")
view.ss.navigationBarColor(.white)
view.ss.customBackButton { Text("Back") }

// List
view.ss.listSpace(10)

// Tap
view.ss.onTapLocal { }

// Transition
view.ss.pushTransition(.move(edge: .trailing))

// Share
view.ss.shareSheet(isPresented: $showShare, items: [url])

// Checkmark
view.ss.checkmark

// Review
view.ss.requestReview()

// App Store
view.ss.appStoreLink(appId: "123456")

// Proposed View Size
view.ss.proposedViewSize { size in
    Text("Width: \(size.width)")
}
```

## Tools Usage

UI Components in `Sources/Brick/Tools/`:

```swift
// Animation
view.onAnimationCompleted(for: value) { }
WithAnimation { } completion: { }

// Blur
BlurView()
GlassBlurView(removeAllFilters: true)
GlassmorphismBlurView()

// CarouselView
CarouselView(items: items) { item in
    Text(item.title)
}
.carouselScale(0.9)
.carouselPagePadding(20)
.carouselPageOutWidth(40)

// Date
Date(year: 2024, month: 1, day: 1)
Date().adding(days: 7)
Date().difference(from: otherDate)
DateFormatter.custom.date(from: string)
JSONEncoder.iso8601
JSONDecoder.iso8601

// Gestures
GestureButton { isPressed in
    Text(isPressed ? "Pressed" : "Tap me")
}
ScrollViewGestureButton { isPressed in
    Text("Scroll Button")
}
view.onSwipeGesture(up: { }, down: { }, left: { }, right: { })

// Keychain
KeychainService.shared.set("value", forKey: "key")
let value = KeychainService.shared.string(forKey: "key")

// Language
LanguageSettings.shared.selectedLanguage = .zhHans
LanguageView { ContentView() }
"hello".localized

// List
List { items }.emptyPlaceholder(items) { Text("Empty") }
LoadMoreView { loadMore() }

// Loading
view.loading(isPresented: $loading) { ProgressView() }
LoadingManager().showLoading()
LoadingManager().showSuccess()

// Navigation
NavigationView { }.navigationItem()
view.hiddenBackButtonTitle()
view.regainSwipeBack()
NavigatorPath().path.push("screen")

// NavigationStack (iOS 14-15)
Brick.NavigationStack(path: $path) { ContentView() }
navigator.push(.detail)
navigator.pop()
navigator.popToRoot()

// OpenUrl
Brick.Link("Open", destination: url)
WebView(url: url)
    .showProgress(true)
    .setProgressColor(.blue)

// Others
FlipView(front: frontView, back: backView, isFlipped: $flipped)
MarqueeText("Long scrolling text...")
RadioButton(isSelected: true, label: "Option") { }
OtpView(activeColor: .blue, inActiveColor: .gray, length: 4) { code in }
ExpandText(lineLimit: 3) { Text("Long text...") } moreView: { action in
    Button("More", action: action)
}
CountDownTimerText(timeCount: 60, titleWhenIdle: "Get", titleWhenFinished: "Retry") { true }

// Page
PageScrollView(pageOutWidth: 50, pagePadding: 10) {
    ForEach(items) { item in Text(item.title) }
}
PageIndicator(count: 5, current: $index)

// Picker
ListPicker(selection: $value, items: items)
ForEachPicker(selection: $value, items: items) { item in
    Text(item.title)
}

// Presentation
view.presentationDetents([.medium, .large])
view.presentationDragIndicator(.visible)
view.presentationCornerRadius(20)
view.interactiveDismissDisabled(false)

// Progress
LinearProgressBar(value: 0.5)
CircularProgressBar(value: 0.5)
    .circularProgressStyle(.gradient(colors: [.red, .blue]))

// Refresh
List { items }
    .enableRefresh(true)
    .enableLoadMore(true)
    .onRefresh { }
    .onLoadMore { }

// ScrollStack
VScrollStack { ForEach(items) { Text($0) } }
HScrollStack { ForEach(items) { Text($0) } }
VScrollGrid(rows: 3) { ForEach(items) { Text($0) } }

// ScrollView
view.ss.scrollIndicators(.hidden)
view.ss.scrollKeyboardDismiss(.onDrag)
view.ss.scrollEnabled(false)

// Segment
CustomSegmentPicker(segments: items, selected: $index) { item in
    Text(item.title)
}

// Shape
Triangle()
RoundedCorner(radius: 10, corners: [.topLeft, .topRight])

// TTextField
TTextField(text: $text)
    .tTextFieldTitle("Name")
    .tTextFieldPlaceHolderText("Enter name")

// Toast
Toast.show("Message")
Toast.show("Message", position: .top, animation: .slide)

// AlertToast (multiple display modes)
.toast(isPresenting: $showAlert) {
    AlertToast(displayMode: .alert, type: .systemImage("checkmark.circle.fill", .green), title: "Success")
}

.toast(isPresenting: $showHUD) {
    AlertToast(displayMode: .hud, type: .loading, title: "Loading...")
}

.toast(isPresenting: $showBanner) {
    AlertToast(displayMode: .banner(.slide), type: .systemImage("info.circle", .blue), title: "Info", subTitle: "Details here")
}

// Custom Toast
.toast(isPresented: $showToast, position: .top, animation: .fade, duration: 2.0) {
    HStack {
        Image(systemName: "star.fill")
        Text("Custom Toast")
    }
    .padding()
    .background(Color.blue)
    .cornerRadius(10)
}

// TextEditors (iOS 15+)
@State private var text = ""

TextEditors("Enter text...", text: $text)
    .frame(height: 100)

// With text limit
TextEditors("Enter text (max 100)", text: $text, textLimit: 100)

// TextEditor Style
TextEditor(text: $text)
    .textEditorStyle(.roundedBorder)

TextEditor(text: $text)
    .textEditorStyle(.roundedColorBorder(.blue, 2))

// UIHostingConfiguration (iOS 15+, deprecated iOS 16+)
myCell.contentConfiguration = Brick.UIHostingConfiguration {
    HStack {
        Image(systemName: "star").foregroundStyle(.purple)
        Text("Favorites")
        Spacer()
    }
}
.background {
    Color.blue
}
.margins(.horizontal, 20)

// UnderLineText
UnderLineText(text: $text)
```

## Bilingual Comment Guidelines

When adding Chinese/English bilingual comments to Swift files:

### Format Rules

1. **Structs and Classes**
```swift
/// 组件名称/Component name
/// 组件功能描述/Component function description
public struct MyComponent: View { }
```

2. **Initializers**
```swift
/// 初始化方法描述/Initialize method description
/// - Parameters:
///   - param1: 参数1描述/Parameter 1 description
///   - param2: 参数2描述/Parameter 2 description
public init(param1: Type1, param2: Type2) { }
```

3. **Properties**
```swift
/// 属性描述/Property description
public var myProperty: Type
```

4. **Methods/Functions**
```swift
/// 方法描述/Method description
/// - Parameter param: 参数描述/Parameter description
/// - Returns: 返回值描述/Return value description
public func myMethod(param: Type) -> ReturnType { }
```

5. **View Modifiers**
```swift
/// 修饰器描述/Modifier description
/// - Parameters:
///   - param: 参数描述/Parameter description
/// - Returns: 修改后的视图/Modified view
public func myModifier(param: Type) -> some View { }
```

6. **Enums and Cases**
```swift
/// 枚举描述/Enum description
public enum MyEnum {
    /// 用例描述/Case description
    case first
    /// 用例描述/Case description
    case second
}
```

7. **Type Aliases**
```swift
/// 类型别名描述/Type alias description
public typealias MyAlias = SomeType
```

### Comment Style Guidelines

- **Chinese first, English second**: Always put Chinese before the slash, English after
- **Keep it concise**: Both languages should be brief and clear
- **Consistent formatting**: Use `///` for all public APIs
- **No redundant comments**: Only comment on public APIs, not private implementation details
- **Match parameter names**: Parameter comments should match the actual parameter names

### Examples

**Good:**
```swift
/// 倒计时文本视图/Count down timer text view
/// 支持自动和手动两种倒计时模式。/Supports both auto and manual countdown modes.
public struct CountDownTimerText: View {
    /// 倒计时总秒数/Total countdown seconds
    let timeCount: Int
    
    /// 初始化倒计时文本/Initialize count down timer text
    /// - Parameters:
    ///   - timeCount: 倒计时总秒数，默认59/Total countdown seconds, default 59
    ///   - mode: 倒计时模式/Countdown mode
    public init(timeCount: Int = 59, mode: Mode = .auto) { }
}
```

**Bad:**
```swift
// This is a countdown timer (English only)
/// 这是一个倒计时 (Chinese only, no English)
/// 倒计时/Countdown timer that counts down from a specified time and shows text when done
// (Too verbose, inconsistent)
```

### File Header

```swift
//
//  FileName.swift
//  ProjectName
//
//  Created by Author on Date.
//  文件描述/File description
//

import SwiftUI
```

### Updating README Files

When adding new components to README:

1. **Components Table**: Add to the table with Feature, Description, Usage columns
2. **API Usage Section**: Add detailed code examples under `##### ComponentName`
3. **Both Languages**: Update both README.md (English) and README_ZH.md (Chinese)





