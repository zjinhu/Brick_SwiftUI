# Brick_SwiftUI

[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 14.0+](https://img.shields.io/badge/Xcode-14.0%2B-blue.svg)
![iOS 14.0+](https://img.shields.io/badge/iOS-14.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)
![SwiftUI 3.0+](https://img.shields.io/badge/SwiftUI-3.0%2B-orange.svg)

### SwiftUI APP Acceleration Development Kit

This Package is related to [Gitee](https://gitee.com/zjinhu/brick). If you feel that the introduction of Github addresses in SPM is slow, you can use Gitee.

Built-in various auxiliary development tools, and the newly added API after iOS15 is compatible with iOS14, please run the demo to view the usage of specific functions

| ![](Image/1.png) | ![](Image/2.png) |
| ---------------- | ---------------- |
|                  |                  |

Versions before 1.0.0 support iOS14, while versions after 1.0.0 use iOS16+Swift6.0

### Wrapped - View Extension Wrappers

Adds functionality to View using the `Brick<Wrapped>` pattern, call via `view.ss.xxx`

```swift
import Brick
// Usage
view.ss.tabBar(.hidden)
view.ss.onChange(of: value) { newValue in }
```

| Feature | Description | Usage |
|---------|-------------|-------|
| **TabbarVisible** | Control TabBar visibility with animation | `view.ss.tabBar(.hidden)` |
| **AppStore** | Generate App Store URL and present product page | `view.ss.showStoreProduct(appID: "123")` |
| **OnChange** | Unified onChange handler, iOS 14-17 compatible | `view.ss.onChange(of: value) { newValue in }` |
| **ShareSheet** | Custom share sheet | `ShareSheetView(activityItems: [...])` |
| **Checkmark** | Custom checkbox toggle style | `view.ss.checkmark(.visible)` / `Toggle("Check", isOn: $bool).toggleStyle(.checkmark)` |
| **Geometry** | Geometry change detection & visual effects | `view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { old, new in }` |
| **Badge** | Badge overlay system | `view.ss.badge { Text("99+") }` |
| **BottomSafeArea** | Custom bottom safe area inset | `view.ss.bottomSafeAreaInset { SomeView() }` |
| **Border** | Border modifier | `view.ss.border(.red, cornerRadius: 8, lineWidth: 2)` |
| **Background** | Background modifier, hide List/TextView background | `view.ss.background { Color.blue }` / `view.ss.hideListBackground()` |
| **Alignment** | Adjust view alignment | `view.ss.alignmentGuideAdjustment(anchor: .topLeading)` |
| **CustomBackButton** | Custom navigation back button | `view.ss.navigationCustomBackButton { Image(systemName: "chevron.left") }` |
| **Task** | Backported .task modifier for iOS 14- | `view.ss.task { await doSomething() }` |
| **TabbarColor** | Set TabBar background color | `view.ss.tabbarColor(.white)` |
| **Submit** | Form submission, custom keyboard return key | `view.ss.onSubmit { submit() }` / `view.ss.submitLabel(.done)` |
| **SafeArea** | Safe area padding | `view.ss.safeAreaPadding(16)` |
| **OnTapLocal** | Get tap location coordinates | `view.ss.onTapGesture { point in print(point) }` |
| **NavigationBarColor** | Set navigation bar background color | `view.ss.navigationBarColor(backgroundColor: .blue)` |
| **ListSpace** | Set List section spacing | `view.ss.listSectionSpace(20)` |
| **Hidden** | Conditional view hiding with transition | `view.ss.hidden(isHidden, transition: .opacity)` |
| **PushTransition** | Edge push/pop transition (iOS 16+) | `AnyTransition.ss.push(from: .leading)` |
| **Overlay** | Overlay modifier | `view.ss.overlay { SomeView() }` |
| **Section** | Backported Section container for iOS 14- | `Brick.Section("Title") { content }` |
| **ProposedViewSize** | Proposed view size struct | `ProposedViewSize.zero` / `.infinity` / `.unspecified` |
| **RequestReview** | App Store review request | `@Environment(\.requestReview) var requestReview` |
| **Shadow** | Shadow modifier | `view.ss.shadow(color: .black, x: 0, y: 2, blur: 4)` |
| **NavigationTitle** | Navigation title with display mode | `view.ss.navigationTitle("Title", displayMode: .large)` |
| **Mask** | Inverted mask for badge effects | `view.ss.invertedMask { Circle() }` |
| **Corner** | Specific corner radius | `view.ss.cornerRadius(10, corners: [.topLeft, .topRight])` |
| **Alert** | UIAlertController button tint | `.alert("Title").ss.alertButtonTint(.white)` |

#### Wrapped Detailed API Usage

##### TabbarVisible - TabBar Visibility Control

```swift
// Control TabBar visibility
view.ss.tabBar(.hidden)  // Hide TabBar
view.ss.tabBar(.visible) // Show TabBar
```

##### OnChange - Value Change Listener

```swift
// iOS 14-17 compatible onChange
view.ss.onChange(of: count) { newValue in
    print("New value: \(newValue)")
}

// With initial value callback (iOS 17+)
view.ss.onChange(of: value, initial: true) { oldValue, newValue in
    print("Changed from \(oldValue) to \(newValue)")
}

// No parameter closure
view.ss.onChange(of: flag) {
    print("Flag changed")
}
```

##### Geometry - Geometry Change Detection

```swift
// Listen to view size changes
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { oldSize, newSize in
    print("Size changed: \(oldSize) -> \(newSize)")
}

// Get new value only
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { newSize in
    print("New size: \(newSize)")
}

// Visual effect
view.ss.visualEffect { anyView, proxy in
    someView
        .frame(width: proxy.size.width)
}
```

##### Badge

```swift
// Basic badge
view.ss.badge {
    Text("99+")
        .font(.caption)
        .foregroundColor(.white)
        .padding(4)
        .background(Color.red)
        .clipShape(Circle())
}

// Custom config
view.ss.badge(
    alignment: .topTrailing,
    anchor: UnitPoint(x: 0.3, y: 0.3),
    scale: 1.2,
    inset: 8
) {
    redCircle
}
```

##### Border

```swift
// Rounded rectangle border
view.ss.border(Color.blue, cornerRadius: 12, lineWidth: 2)

// Capsule border
view.ss.borderCapsule(Color.green, lineWidth: 1)

// Custom shape border
view.ss.border(LinearGradient(...), width: 3, cornerRadius: 8)
```

##### Task - Async Task (iOS 14-)

```swift
// Basic async task
view.ss.task {
    let data = await fetchData()
    print(data)
}

// With priority
view.ss.task(priority: .background) {
    await heavyWork()
}

// Task with ID cancellation (re-executes when value changes)
view.ss.task(id: itemId) {
    await fetchItem(itemId)
}
```

##### Submit - Form Submission

```swift
// Submit action
TextField("Enter text", text: $text)
    .ss.onSubmit {
        submitForm()
    }

// Submit label (keyboard return key)
TextField("Username", text: $username)
    .ss.submitLabel(.next)

TextField("Password", text: $password)
    .ss.submitLabel(.done)
```

##### SafeArea - Safe Area Padding

```swift
// Uniform padding
view.ss.safeAreaPadding(16)

// Specific edges
view.ss.safeAreaPadding(.horizontal, 20)

// Using EdgeInsets
view.ss.safeAreaPadding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
```

##### Hidden - Conditional Hiding

```swift
// Simple hiding
view.ss.hidden(isLoading)

// With transition
view.ss.hidden(isHidden, transition: .slide)
view.ss.hidden(isHidden, transition: .scale)
view.ss.hidden(isHidden, transition: .opacity)
```

##### Corner - Specific Corner Radius

```swift
import UIKit

// Top corners only
view.ss.cornerRadius(10, corners: [.topLeft, .topRight])

// Bottom corners only
view.ss.cornerRadius(10, corners: [.bottomLeft, .bottomRight])

// Top-left only
view.ss.cornerRadius(10, corners: [.topLeft])
```

##### Shadow

```swift
view.ss.shadow(color: .black.opacity(0.2), x: 0, y: 4, blur: 8)
```

##### Checkmark

```swift
// View modifier
view.ss.checkmark(.visible)

// Toggle style
Toggle(" Agree to terms", isOn: $agreed)
    .toggleStyle(.checkmark)
```

### SwiftUI - SwiftUI Type Extensions

SwiftUI type extensions providing convenient functionality for SwiftUI development.

| Feature | Description | Usage |
|---------|-------------|-------|
| **View++** | View extensions: `.then()`, `.hidden()`, `.offset()`, `.fill()`, `.fit()`, `.hideKeyboard()` | `view.then { $0.padding() }` |
| **ForEach++** | ForEach enhancement: index access, `.interleave()`, `.interdivided()`, `.interspaced()` | `ForEach(items) { item in }` |
| **View+Geometry** | Bind view geometry: `bindSafeAreaInsets`, `bindSize` | `view.bindSize($size)` |
| **View+Haptic** | Haptic feedback: `HapticButton`, tap/change/selection feedback | `.hapticFeedback(.success)` |
| **View+Frame** | Frame extensions: `.minWidth()`, `.maxWidth()`, `.height()`, `.readHeight()` | `.minWidth(100)` |
| **View+Mask** | Mask extensions: `.mask()`, `.masking()`, `.reverseMask()` | `.reverseMask { Circle() }` |
| **View+Background** | Background extensions: `PassthroughView`, `.backgroundFill()` | `.backgroundFill(Color.blue)` |
| **Image++** | Image extensions: `.symbol()`, `.resized()`, `.sizeToFit()` | `Image(systemName: "heart").symbol(...)` |
| **View+Conditionals** | Conditional views: `.enabled()`, `.hidden(if)`, `.visible(if)` | `.hidden(if: isHidden)` |
| **Text++** | Text extensions | `Text("Hello").bold()` |
| **Label++** | Label extensions | `Label("Title", systemImage: "star")` |
| **List++** | List extensions | `List { ... }.listStyle(.insetGrouped)` |
| **Section++** | Section extensions | `Section("Header") { ... }` |
| **NavigationLink++** | NavigationLink extensions | `NavigationLink(destination: View)` |
| **Shape++** | Shape extensions | `Circle()`, `RoundedRectangle()` |
| **Spacer++** | Spacer extensions | `Spacer().frame(height: 10)` |
| **Menu++** | Menu extensions | `Menu { ... }` |
| **Angle++** | Angle extensions | `Angle(degrees: 45)` |
| **Collection++** | Collection extensions | `[1,2,3].safeSubscript(0)` |
| **URL++** | URL extensions | `URL(string: "...")` |
| **String++** | String extensions | `"hello".localized` |
| **Task+** | Task extensions | `Task.sleep(1000000000)` |
| **GridItem++** | GridItem extensions | `GridItem(.flexible())` |

#### SwiftUI Detailed API Usage

##### View++ (View Extension)

```swift
// Chain view modifications
view.then { $0.padding() }
    .then { $0.background(Color.blue) }

// Conditional hiding
view.hidden(isHidden)

// Offset helpers
view.offset(point)
view.offset(length)
view.inset(length)

// Fill/Fit parent view
view.fill(alignment: .center)
view.fit()

// Transition
view.transition(.scale)
view.asymmetricTransition(insertion: .opacity, removal: .move(edge: .leading))

// Type erasure
view.eraseToAnyView()
view.any()

// Hide keyboard (iOS)
view.hideKeyboard()

// Conditional tap gesture
view.onTapGesture(count: 2, disabled: isDisabled) {
    // handle tap
}

// Fill parent view
view.fill(alignment: .center)

// Fit parent view (maintain aspect ratio)
view.fit()

// Set tint color
view.tintColor(.red)

// Conditional tap on background
view.onTapGestureOnBackground {
    // handle background tap
}
```

##### ForEach++ (ForEach Enhancement)

```swift
// With index access
ForEach(items, id: \.id) { index, item in
    Text("\(index): \(item.name)")
}

// Interleave with separator
ForEach(items) { item in
    Text(item.name)
}.interleave(with: Divider())

// Interdivide (with Divider)
ForEach(items) { item in
    Text(item.name)
}.interdivided()

// Interspaced (with Spacer)
ForEach(items) { item in
    Text(item.name)
}.interspaced()
```

##### View+Geometry

```swift
@State private var size: CGSize = .zero
@State private var safeArea: EdgeInsets = .zero

view.bindSize(to: $size)
view.bindSafeAreaInsets(to: $safeArea)
```

##### View+Haptic (Haptic Feedback)

```swift
// Haptic button
HapticButton {
    print("tapped")
} label: {
    Text("Tap me")
}

// Haptic feedback
hapticFeedback()
hapticFeedback(type: .success)
hapticFeedback(type: .medium)

// View haptics modifiers
view.haptics(onChangeOf: value, type: .success)
view.haptics(when: status, equalsTo: "success", type: .warning)
view.haptics(onChangeOf: count, type: .light)
view.triggersHapticFeedbackWhenAppear()
```

##### View+Frame

```swift
// Min/Max width & height
view.minWidth(100)
view.maxWidth(200)
view.minHeight(50)
view.maxHeight(150)

// Width & height
view.width(100)
view.height(50)

// Relative size
view.relativeWidth(0.5)
view.relativeHeight(0.3)
view.relativeSize(width: 0.5, height: 0.3)

// Read size
view.readHeight { height in print(height) }
view.readWidth { width in print(width) }

// Square frame
view.squareFrame()
view.squareFrame(sideLength: 100)

// Ideal frame
view.idealFrame(width: 100, height: 50)
```

##### View+Mask

```swift
// Mask
view.mask(Circle())

// Masking (inverse)
view.masking {
    Circle()
}

// Reverse mask (for badge effects)
view.reverseMask(alignment: .topTrailing) {
    Circle()
        .frame(width: 20, height: 20)
}
```

##### View+Background

```swift
// Background
view.background(Color.red)
view.background {
    Image("bg")
}

// Background fill (ignoring safe area)
view.backgroundFill(Color.blue)
view.backgroundFill {
    LinearGradient(...)
}

// PassthroughView
PassthroughView {
    Color.red
}
```

##### Image++

```swift
// Symbol with config
Image(systemName: "heart")
    .symbol(variableColor: .blue)
    .symbolRenderingMode(.hierarchical)

// Resize image
Image(systemName: "heart")
    .resized(toWidth: 100)
    .resized(toHeight: 50)

// Size to fit
image.sizeToFit()

// Load async image
AsyncImage(url: url)
    .loadAsync()
```

##### View+Conditionals

```swift
// Enable/disable view
view.enabled(isEnabled)
view.enabled(isEnabled, removeFromHierarchy: true)

// Conditional visibility
view.hidden(if: isHidden)
view.visible(if: isVisible)

// Conditional modifier
view.modifier(if: shouldApply) {
    SomeModifier()
}
```

##### Text++

```swift
// Text styling
Text("Hello")
    .bold()
    .italic()
    .underline()
    .strikethrough()
    .monospaced()
    .smallCaps()
    .textCase(.uppercase)
    .textCase(.lowercase)

// Tracking
Text("Hello")
    .tracking(2)
    .tracking(-0.5)
```

##### Label++

```swift
// Label with icon
Label("Title", systemImage: "star")
Label {
    Text("Content")
} icon: {
    Image(systemName: "star")
}
```

##### List++

```swift
// List with style
List {
    // content
}
.listStyle(.insetGrouped)
.listStyle(.plain)
.listStyle(.inset)
.listStyle(.sidebar)

// List row background
.listRowBackground(Color.clear)
```

##### Section++

```swift
// Section with header
Section("Header") {
    Text("Content")
}

// Section with header and footer
Section(header: Text("Header"), footer: Text("Footer")) {
    Text("Content")
}
```

##### NavigationLink++

```swift
// Push navigation
NavigationLink(destination: DetailView()) {
    Text("Go to Detail")
}

// Value-based navigation
NavigationLink(value: item) {
    Text(item.name)
}
.navigationDestination(for: Item.self) { item in
    DetailView(item: item)
}
```

##### Shape++

```swift
// Rounded rectangle
RoundedRectangle(cornerRadius: 10)
RoundedRectangle(cornerRadius: 10, style: .continuous)

// Capsule
Capsule()
Capsule(style: .continuous)

// Custom shapes
Rectangle()
Circle()
Ellipse()
```

##### Spacer++

```swift
// Spacer with min length
Spacer(minLength: 20)

// Spacer with frame
Spacer()
    .frame(height: 10)
```

##### Menu++

```swift
// Basic menu
Menu("Actions") {
    Button("Action 1") { }
    Button("Action 2") { }
}

// Menu with label
Menu {
    Button("Edit") { }
    Button("Delete") { }
} label: {
    Image(systemName: "ellipsis.circle")
}
```

##### Angle++

```swift
// Angle from degrees
Angle(degrees: 45)

// Angle from radians
Angle(radians: .pi / 4)

// Rotate content
content
    .rotationEffect(Angle(degrees: 45))
```

##### Collection++

```swift
// Safe subscript
let item = array[safe: 0]  // Returns nil if out of bounds

// First/last
array[safe: \.first]
array[safe: \.last]

// Boundary safe
array[safe: 0...5]
array[safe: 0..<5]
```

##### URL++

```swift
// URL with query parameters
var components = URL(string: "https://example.com")
components?.queryItems = [
    URLQueryItem(name: "key", value: "value")
]

// Check URL validity
url?.isValid
```

##### String++

```swift
// Case transformations
"hello".uppercasedFirst()  // "Hello"
"hello".lowercasedFirst()  // "hello"
"hello_world".camelcased()  // "helloWorld"
"HelloWorld".snakecased()  // "hello_world"
"hello world".titlecased() // "Hello World"

// URL encoding
"hello world".urlEscaped()  // "hello%20world"

// Line handling
"line1\nline2".lines()  // ["line1", "line2"]

// Whitespace handling
"  hello  world  ".trimmed()  // "hello world"

// Pattern replacement
"hello".replacing("l", with: "r")  // "herro"

// Validation
"https://example.com".isValidUrl  // true
"   ".isBlank  // true

// Prefix/suffix removal
"hello world".droppingPrefix("hello ")  // "world"
"hello world".droppingSuffix(" world")  // "hello"

// Take last characters
"hello".take(last: 3)  // "llo"

// Random string
String.random(length: 10)

// Truncation
"Hello World".truncate(5)  // "He..."
"Hello World".truncate(5, position: .head)  // "...rld"
"Hello World".truncate(5, position: .middle)  // "He...ld"

// Nil if empty/blank
"".nilIfEmpty  // nil
"   ".nilIfBlank  // nil
```

##### Task+

```swift
// Sleep
try? await Task.sleep(1_000_000_000) // 1 second

// Task with timeout
try? await Task.timeout(after: 1.0) {
    await someWork()
}
```

##### GridItem++

```swift
// Flexible grid item
GridItem(.flexible())
GridItem(.flexible(spacing: 10))
GridItem(.flexible(spacing: 10, alignment: .leading))

// Fixed grid item
GridItem(.fixed(100))
GridItem.fixed(100)

// Adaptive grid item
GridItem.adaptive(minimum: 50, maximum: 100)

// Array of grid items
[GridItem].fixed([100, 200, 100])
[GridItem].adaptive(minimum: 80, maximum: .infinity)
[GridItem].flexible(minimum: 50, maximum: 200)

// GridItem.Size
GridItem.Size.adaptive(100)
```

### Tools - UI Components

Pre-built UI components for rapid development.

| Feature | Description | Usage |
|---------|-------------|-------|
| **NavigationStack** | Navigation stack (iOS 16-) | `NavigationStack { ... }` |
| **Page** | Paging scroll view with PageIndicator | `PageScrollView(pageOutWidth: 50, pagePadding: 10) { ... }` |
| **Toast** | Toast messages with position (top/bottom), animation types | `Toast.show("Message")` |
| **ListPicker** | Generic list picker with sections, single/multi selection | `ListPicker(selection: $value, items: [])` |
| **TTextField** | Custom styled text field with title, placeholder, error states | `TTextField(title: "Name", text: $text)` |
| **CarouselView** | Horizontal carousel with scaling, wrapping, auto-scroll | `CarouselView(items: [])` |
| **FlipView** | 3D flip card view | `FlipView(front: View, back: View)` |
| **OpenUrl** | URL opening tools | `OpenURL(url)` |
| **WebView** | WebView component | `WebView(url: url)` |
| **Presentation** | Presentation controls: DragIndicator, Detents, CornerRadius | `presentationDetents([.medium, .large])` |
| **TextEditors** | TextEditor style extensions | `TextEditor(text: $text).style(...)` |
| **UnderLineText** | Underline text input | `UnderLineText(text: $text)` |
| **UIHostingConfiguration** | UIKit cell content configuration | `UIHostingConfiguration { ... }` |
| **Loading** | Loading overlay with animation | `.loading(isPresented: $loading) { ... }` |
| **Refresh** | Pull-to-refresh for List/ScrollView | `.enableRefresh(true)` |
| **ScrollView** | ScrollView helpers: indicators, keyboard dismiss, enabled | `.ss.scrollIndicators(.hidden)` |
| **ScrollStack** | Lazy scrollable stacks and grids | `VScrollStack { ... }` / `HScrollStack { ... }` |
| **Triangle** | Triangle shape | `Triangle()` / `Triangle(inverted: true)` |
| **RoundedCorner** | Rounded corner shape | `RoundedCorner(radius: 10)` |
| **CustomSegmentPicker** | Custom segmented picker | `CustomSegmentPicker(selection: $index, segments: [])` |

#### Tools Detailed API Usage

##### CarouselView

```swift
// Basic carousel
CarouselView(items, id: \.id) { item in
    Image(item.imageURL)
        .resizable()
        .aspectRatio(contentMode: .fill)
}
.index($currentIndex)

// With custom configuration
CarouselView(
    items,
    id: \.id,
    index: $currentIndex,
    spacing: 10,
    headspace: 20,
    sidesScaling: 0.85,
    isWrap: true,
    autoScroll: .active(3),
    canMove: true
) { item in
    BannerView(item: item)
}

// Auto scroll options
CarouselAutoScroll.inactive        // No auto scroll
CarouselAutoScroll.active(5)        // Auto scroll every 5 seconds
CarouselAutoScroll.defaultActive    // Default 5 seconds
```

##### Page

```swift
// Basic page scroll view
@State private var currentPage = 0

PageScrollView(pageOutWidth: 50, pagePadding: 10) {
    ForEach(0..<10, id: \.self) { index in
        RoundedRectangle(cornerRadius: 20)
            .fill(.orange)
            .overlay {
                Text("Page \(index)")
            }
    }
}
.frame(height: 228)

// With PageIndicator
VStack {
    PageScrollView(pageOutWidth: 40, pagePadding: 20) {
        ForEach(bannerItems) { item in
            BannerView(item: item)
        }
    }
    .frame(height: 200)
    
    PageIndicatorView(
        numPages: bannerItems.count,
        currentPage: $currentPage,
        height: 8,
        currentWidth: 20,
        spacing: 8,
        color: .white
    )
}
.background(Color.black)
```

##### NavigationStack

```swift
// Basic NavigationStack (iOS 14-15 compatible, deprecated on iOS 16+)
@State private var path: [String] = []

Brick.NavigationStack(path: $path) {
    List {
        ForEach(items, id: \.self) { item in
            NavigationLink(item, value: item)
        }
    }
    .navigationDestination(for: String.self) { item in
        DetailView(item: item)
    }
}

// Without path binding (internal path management)
Brick.NavigationStack {
    List {
        NavigationLink("Detail", value: "detail1")
        NavigationLink("Detail", value: "detail2")
    }
    .navigationDestination(for: String.self) { value in
        DetailView(title: value)
    }
}

// Using Navigator (programmatic navigation)
@EnvironmentObject var navigator: Navigator<String>

Button("Push Detail") {
    navigator.push("newDetail")
}

Button("Pop") {
    navigator.pop()
}

Button("Pop to Root") {
    navigator.popToRoot()
}

Button("Pop to Index") {
    navigator.popTo(index: 2)
}

Button("Pop to Condition") {
    navigator.popTo(where: { $0 == "target" })
}

// Using PathNavigator (AnyHashable)
@EnvironmentObject var pathNavigator: PathNavigator

pathNavigator.push("newScreen")
pathNavigator.popTo(String.self)

// Custom Navigation Policy
struct ContentView: View {
    var body: some View {
        NavigationStack(path: $path) {
            // Content
        }
        .environment(\.useNavigationStack, .whenAvailable) // Use NavigationStack when available (iOS 16+)
        .environment(\.useNavigationStack, .never) // Always use NavigationView (iOS 14-15)
    }
}
```

##### TTextField

```swift
// Basic usage
@State private var text = ""

TTextField(text: $text)
    .tTextFieldTitle("Username")
    .tTextFieldPlaceHolderText("Enter username")
    .tTextFieldTextColor(.black)
    .tTextFieldTitleColor(.gray)

// With error state
@State private var hasError = false
@State private var errorMessage = "Invalid input"

TTextField(text: $text, error: $hasError, errorText: $errorMessage)
    .tTextFieldTitle("Email")
    .tTextFieldPlaceHolderText("Enter email")

// Secure text field
TTextField(text: $password)
    .tTextFieldSecure(true)
    .tTextFieldSecureImage(open: .eye, close: .eyeSlash)

// Custom styling
TTextField(text: $text)
    .tTextFieldTitleFont(.headline)
    .tTextFieldErrorFont(.caption)
    .tTextFieldPlaceHolderFont(.subheadline)
    .tTextFieldBackgroundColor(.white)
    .tTextFieldBorderColor(.gray)
    .tTextFieldErrorTextColor(.red)
    .tTextFieldFocusedBorderColor(.blue)
    .tTextFieldFocusedBorderColorEnable(true)
    .tTextFieldBorderType(.square)
    .tTextFieldBorderWidth(1)
    .tTextFieldCornerRadius(8)
    .tTextFieldHeight(44)

// With leading/trailing views
TTextField(text: $text)
    .tTextFieldLeadingView {
        Image(systemName: "person")
            .foregroundColor(.gray)
    }
    .tTextFieldTrailingView {
        Button(action: {}) {
            Image(systemName: "xmark.circle.fill")
        }
    }

// Input limits
TTextField(text: $text)
    .tTextFieldLimitCount(20)
    .tTextFieldTruncationMode(.tail)

// Disable auto-correction
TTextField(text: $text)
    .tTextFieldDisableAutoCorrection(true)
```

##### ListPicker

```swift
// Basic single selection picker
@State private var selectedItem: Item?

ListPicker(selection: $selectedItem, items: items) { item, isSelected in
    ListSelectItem(isSelected: isSelected) {
        Text(item.name)
    }
}

// With sections
@State private var selected: Item?

ListPicker(
    sections: [
        ListPickerSection(title: "Section 1", items: items1),
        ListPickerSection(title: "Section 2", items: items2)
    ],
    selection: $selected
) { item, isSelected in
    ListSelectItem(isSelected: isSelected) {
        HStack {
            Image(item.icon)
            Text(item.name)
        }
    }
}

// Multi selection picker
@State private var selectedItems: [Item] = []

ListMultiPicker(selection: $selectedItems, items: items) { item, isSelected in
    ListSelectItem(isSelected: isSelected) {
        Text(item.name)
    }
}

// With custom indicator
ListSelectItem(isSelected: isSelected, selectIndicator: Image(systemName: "checkmark.circle.fill")) {
    Text("Item name")
}

// Optional binding fallback
@State private var optionalValue: Double?

func doSomething(with binding: Binding<Double>) { ... }

doSomething(with: $optionalValue ?? 0)
```

##### Presentation

```swift
// Detents (iOS 15+)
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}

// With selection binding
@State private var selectedDetent: PresentationDetent = .medium

.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationDetents([.medium, .large], selection: $selectedDetent)
}

// Interactive dismiss
.sheet(isPresented: $showSheet) {
    ContentView()
        .interactiveDismissDisabled()  // Disable dismiss
}

// Custom corner radius (iOS 15+)
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationCornerRadius(20)
}

// Background interaction
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationBackground(Color.clear)
        .presentationBackgroundInteraction(.upwards)
}

// Content interaction
.sheet(isPresented: $showSheet) {
    ContentView()
        .contentShapeSumo(.rect)
}
```

##### Loading

```swift
// Basic loading
@State private var isLoading = false

Button("Show Loading") {
    isLoading = true
}
.loading(isPresented: $isLoading) {
    ProgressView()
        .scaleEffect(1.5)
}

// With options
.loading(
    isPresented: $isLoading,
    options: LoadingOptions(
        hideAfter: 3.0,          // Auto hide after 3 seconds
        backdrop: .black.opacity(0.5),  // Dark backdrop
        animation: .easeInOut,
        modifierType: .fade,    // or .scale
        dismissOnTap: true       // Tap to dismiss
    )
) {
    VStack {
        ProgressView()
        Text("Loading...")
            .foregroundColor(.white)
    }
    .padding(30)
    .background(Color.gray.opacity(0.8))
    .cornerRadius(10)
}
```

##### Progress

```swift
// Linear Progress Bar
@State private var progress: Double = 0.5

LinearProgressBar(progress: progress)
    .linearProgressBarStyle(.standard)

// With custom style
LinearProgressBar(progress: 0.8)
    .linearProgressBarStyle(.padding)

LinearProgressBar(progress: 0.6)
    .linearProgressBarStyle(.tallPadding)

// Custom style
extension LinearProgressBar.Style {
    static var customStyle: LinearProgressBar.Style = {
        var style = LinearProgressBar.Style.standard
        style.backgroundColor = .gray.opacity(0.2)
        style.barColor = .blue
        style.height = 8
        style.animation = .easeInOut
        return style
    }()
}

LinearProgressBar(progress: 0.7)
    .linearProgressBarStyle(.customStyle)

// Circular Progress Bar
CircularProgressBar(progress: 0.65)
    .circularProgressBarStyle(.standard)

// Without text
CircularProgressBar(progress: 0.8)
    .circularProgressBarStyle(.noText)

// Custom circular style
CircularProgressBar(progress: 0.9)
    .circularProgressBarStyle(CircularProgressBar.Style(
        animation: .easeIn(duration: 3),
        backgroundColor: .blue,
        decimals: 2,
        strokeColor: .yellow,
        strokeWidth: 5,
        startAngle: 45,
        progressColor: .yellow,
        progressWidth: 15,
        titleColor: .yellow,
        titleFont: .title.bold()
    ))

// ProgressView with custom style
ProgressView(value: 0.5)
    .progressViewStyle(.heightBar(height: 10, foregroundColor: .blue))

ProgressView(value: 0.7)
    .progressViewStyle(.heightBar(
        height: 6,
        foregroundColor: .green,
        backgroundColor: .gray.opacity(0.3)
    ))

// Circular progress style
ProgressView(value: 0.6)
    .progressViewStyle(CircularProgressStyle(strokeColor: .blue, strokeWidth: 8))

// Flickering view (loading animation)
FlickeringView(count: 5)
    .frame(width: 100, height: 100)
    .foregroundColor(.blue)
```

##### Refresh

```swift
// Enable pull-to-refresh on List
@State private var isRefreshing = false

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)

// With default header
List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshHeader {
    DefaultRefreshHeader(refreshing: $isRefreshing, refreshText: "Pull to refresh") {
        // Refresh action - load new data
        await loadData()
        isRefreshing = false
    }
}

// Custom header with progress
@State private var refreshing = false

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshHeader {
    Refresh.Header(refreshing: $refreshing) { progress in
        // progress: 0.0 to 1.0+ (triggers refresh at > 1.0)
        VStack {
            if refreshing {
                ProgressView()
            } else {
                Text("Pull down: \(Int(progress * 100))%")
            }
        }
    } action: {
        await loadData()
    }
}

// With default footer (load more)
@State private var isLoadingMore = false

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshFooter {
    DefaultFooter(refreshing: $isLoadingMore, noMoreText: "No more data") {
        await loadMore()
    }
}

// Custom footer with no more state
@State private var loading = false
@State private var hasMoreData = true

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshFooter {
    Refresh.Footer(refreshing: $loading) {
        HStack {
            if loading {
                ProgressView()
                Text("Loading more...")
            }
        }
    }
    .noMore(!hasMoreData)  // Hide footer when no more data
    .preload(offset: 50)  // Trigger 50pt before reaching bottom
}

// Refresh namespace types
typealias RefreshHeader = Refresh.Header
typealias RefreshFooter = Refresh.Footer
typealias DefaultRefreshHeader = Refresh.DefaultHeader
typealias DefaultRefreshFooter = Refresh.DefaultFooter
```

##### ScrollView

```swift
// Hide scroll indicators
ScrollView {
    VStack(alignment: .leading) {
        ForEach(0..<100) {
            Text("Row \($0)")
        }
    }
}
.ss.scrollIndicators(.hidden)

// Show specific axis indicators
ScrollView {
    LazyVStack {
        ForEach(0..<50, id: \.self) { i in
            Text("Item \(i)")
        }
    }
}
.ss.scrollIndicators(.visible, axes: .vertical)

// Disable scrolling
@State private var isScrollDisabled = false

ScrollView {
    VStack {
        Toggle("Disable", isOn: $isScrollDisabled)
        MyContent()
    }
}
.ss.scrollDisabled(isScrollDisabled)

// Keyboard dismiss behavior
@State var text = ""

ScrollView {
    TextField("Prompt", text: $text)
    ForEach(0 ..< 50) { index in
        Text("\(index)")
            .padding()
    }
}
.ss.scrollDismissesKeyboard(.immediately)

// Different keyboard dismissal modes
.ss.scrollDismissesKeyboard(.automatic)  // Default behavior
.ss.scrollDismissesKeyboard(.interactively)  // Interactive dismissal
.ss.scrollDismissesKeyboard(.never)  // Never dismiss

// ScrollViewTracking - Track scroll position
@State private var currentScroll: CGFloat = 0

ScrollTrackingView(currentScroll: $currentScroll) {
    ForEach(0..<20, id: \.self) { index in
        Text("Item \(index)")
            .padding()
    }
}
// Use onScroll to listen to scroll changes
.onScroll { offset in
    print("Scroll offset: \(offset)")
}
```

##### UnderLineText

```swift
// Basic usage
@State private var text = ""
@State private var date = Date()

UnderLineText()
    .underLineText(text)
    .underLineTitle("Name")
    .underLineColor(.gray)

// With leading/trailing views
UnderLineText()
    .underLineText("Some Text")
    .underLineTitle("Label")
    .underLineLeadingView {
        Image(systemName: "person")
    }
    .underLineTrailingView {
        DatePicker("", selection: $date, displayedComponents: .date)
    }

// Custom styling
UnderLineText()
    .underLineText("Custom")
    .underLineTitle("Title")
    .underLineTitleColor(.gray)
    .underLineTitleFont(.headline)
    .underLineTextColor(.black)
    .underLineTextFont(.body)
    .underLineColor(.blue)
    .underLineHeight(1)
    .underLineTextHeight(40)
```

##### TextEditors

```swift
// Basic usage
@State private var text = ""

TextEditors("Enter your text here", text: $text)
    .frame(height: 150)
    .border(Color.gray)

// With custom padding
TextEditors("Placeholder text", text: $text)
    .padding(10)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)

// With text limit
@State private var limitedText = ""

TextEditors("Max 100 characters", text: $limitedText, textLimit: 100)
    .frame(height: 100)
```

##### TextEditorStyle

```swift
// Automatic/Plain style
TextEditor(text: $text)
    .textEditorStyle(.automatic)

// Rounded border
TextEditor(text: $text)
    .textEditorStyle(.roundedBorder)

// Custom color border
TextEditor(text: $text)
    .textEditorStyle(.roundedColorBorder(.blue, 2))

// Custom color with different width
TextEditor(text: $text)
    .textEditorStyle(.roundedColorBorder(.red, 5))
```

##### UIHostingConfiguration

```swift
// For UITableViewCell
cell.contentConfiguration = UIHostingConfiguration {
    HStack {
        Image(systemName: "star")
            .foregroundStyle(.purple)
        Text("Favorites")
        Spacer()
    }
}

// With background
cell.contentConfiguration = UIHostingConfiguration {
    HStack {
        Image(systemName: "star")
            .foregroundStyle(.purple)
        Text("Favorites")
        Spacer()
    }
}
.background {
    Color.blue
}

// With margins
cell.contentConfiguration = UIHostingConfiguration {
    Text("My Contents")
}
.margins(.horizontal, 20)
.margins(.vertical, 10)

// For UICollectionViewCell
collectionCell.contentConfiguration = UIHostingConfiguration {
    VStack {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
        Text("Image Title")
    }
}
.background(Color.gray.opacity(0.1))
.margins(.all, 8)
```

##### Triangle

```swift
// Basic upward triangle
Triangle()
    .fill(Color.blue)

// Inverted (downward) triangle
Triangle(inverted: true)
    .fill(Color.red)

// With stroke
Triangle()
    .stroke(Color.green, lineWidth: 2)

// Custom size
Triangle()
    .frame(width: 100, height: 100)
    .fill(Color.orange)
```

##### RoundedCorner

```swift
// All corners rounded
RoundedCorner(radius: 20, corners: .allCorners)
    .fill(Color.gray)

// Specific corners (iOS)
RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
    .fill(Color.blue)

RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight])
    .fill(Color.green)

// Single corner
RoundedCorner(radius: 25, corners: .topLeft)
    .fill(Color.red)

// Apply to view
Rectangle()
    .clipShape(RoundedCorner(radius: 20, corners: .allCorners))
```

##### CustomSegmentPicker

```swift
// Define segment items
struct SegmentItem: Identifiable {
    let id = UUID()
    let title: String
}

@State private var selectedSegment: SegmentItem

// Basic usage
CustomSegmentPicker(
    segments: segments,
    selected: $selectedSegment,
    content: { item in
        Text(item.title)
            .padding()
    },
    background: {
        Capsule()
    }
)

// With custom colors
CustomSegmentPicker(
    segments: segments,
    selected: $selectedSegment,
    normalColor: .gray,
    selectedColor: .white,
    selectedBackColor: .blue,
    bgColor: .gray.opacity(0.2),
    animation: .easeInOut(duration: 0.3),
    content: { item in
        HStack {
            Image(systemName: item.icon)
            Text(item.title)
        }
        .padding()
    },
    background: {
        RoundedRectangle(cornerRadius: 10)
    }
)

// With RoundedRectangle background
CustomSegmentPicker(
    segments: items,
    selected: $selectedItem,
    normalColor: .black,
    selectedColor: .white,
    selectedBackColor: .orange,
    bgColor: .gray.opacity(0.3),
    content: { item in
        Text(item.name)
            .font(.headline)
    },
    background: {
        RoundedRectangle(cornerRadius: 8)
    }
)
```

##### ScrollStack

```swift
// Vertical scroll stack (VStack with scrolling)
VScrollStack(spacing: 10, showsIndicators: true) {
    ForEach(0..<20, id: \.self) { index in
        Text("Item \(index)")
            .padding()
    }
}

// Horizontal scroll stack (HStack with scrolling)
HScrollStack(spacing: 15, showsIndicators: false) {
    ForEach(0..<10, id: \.self) { index in
        Image(systemName: "star.fill")
            .font(.largeTitle)
    }
}

// Vertical scroll grid (3 columns)
VScrollGrid(rowsCount: 3, spacing: 10) {
    ForEach(0..<12, id: \.self) { index in
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.blue.opacity(0.6))
            .frame(height: 60)
    }
}

// Horizontal scroll grid (2 rows)
HScrollGrid(rowsCount: 2, spacing: 10) {
    ForEach(0..<8, id: \.self) { index in
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.green.opacity(0.6))
            .frame(width: 80)
    }
}

// Fixed width columns
VScrollGrid.fixedColumns(widths: [80, 120, 80], spacing: 8) {
    ForEach(0..<9, id: \.self) { index in
        Text("Col \(index)")
    }
}

// Adaptive columns (auto-fit)
VScrollGrid.adaptiveColumns(minimum: 100, spacing: 10) {
    ForEach(0..<15, id: \.self) { index in
        Text("Item \(index)")
    }
}

// Single row horizontal grid (common for horizontal lists)
HScrollGrid.singleRow(height: 80, spacing: 12) {
    ForEach(0..<10, id: \.self) { index in
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.mint.opacity(0.7))
            .frame(width: 100)
    }
}
```

### Utilities - Core Utilities

Core utility tools providing essential functionality for app development.

| Feature | Description | Usage |
|---------|-------------|-------|
| **Brick** | Core wrapper type `Brick<Wrapped>`, enables `view.ss.xxx` syntax | `view.ss.tabBar(.hidden)` |
| **SFSymbols** | SF Symbol type-safe wrapper (V1-V7) | `Image(systemName: SFSymbols.V1.heart)` |
| **Keyboard** | Keyboard manager, track keyboard height | `KeyboardManager.shared.keyboardHeight` |
| **Color+** | Color extensions: Hex init, dynamic colors, random colors | `Color(hex: "#FF5733")` |
| **UIColor++** | UIColor extensions: Hex init, RGB init, dynamic colors | `UIColor(hex: 0xFF5733)` |
| **UIView++** | UIView/NSView extensions: parentController, allSubviews() | `view.allSubviews()` |
| **Screen++** | Screen utilities: safeArea, dimensions, device detection | `Screen.width`, `Screen.safeArea` |
| **CGSize++** | CGSize extensions: greatestFiniteSize, min/max dimension | `CGSize.greatestFiniteSize` |
| **Image+** | Image extensions: resize, tint, rotate, save to photos | `image.resized(toWidth: 500)` |
| **Adapter** | Responsive design adapter, zoom calculations | `100.zoom()`, `10.screen.width(...)` |
| **CurrentLanguage** | Current language detection | `Brick.Language.currentLanguage` |
| **Application** | App info: appName, version, buildNumber, appState | `Brick.Application.appName` |
| **BrickLog** | Logging: debug, info, warning, error, fault | `Log.info("message")` |
| **ViewLifeCycle** | View lifecycle: onFirstAppear, onDidDisappear, onWillDisappear | `view.onFirstAppear { }` |

#### Utilities Detailed API

##### BrickLog

```swift
// Static methods
Log.info("Info message")
Log.debug("Debug message")
Log.warning("Warning message")
Log.error("Error message")
Log.fault("Fault message")

// Instance methods
let logger = BrickLog.create(category: "MyLog")
logger.info("Custom log")
logger.error(.init("Error: \(error)"))
```

##### Color

```swift
// Hex initialization
Color(hex: 0xFF5733)           // UInt64
Color(hex: "#FF5733")           // String
Color.hex(0xFF5733)             // Static method

// Dynamic colors (light/dark)
Color.dynamic(light: "#FFFFFF", dark: "#000000")

// Random colors
Color.random()
Color.random(in: 0.5...1.0, randomOpacity: true)
```

##### Keyboard

```swift
@StateObject private var keyboardManager = KeyboardManager()

var body: some View {
    VStack {
        Text("Keyboard height: \(keyboardManager.keyboardHeight)")
    }
    .onAppear {
        // Hide keyboard
        KeyboardManager.hideKeyboard()
    }
}
```

##### Application

```swift
// App information
Brick.Application.appName           // App name
Brick.Application.appBundleID       // Bundle ID
Brick.Application.versionNumber      // Version (e.g. "1.0.0")
Brick.Application.buildNumber        // Build number
Brick.Application.completeAppVersion // "1.0.0 (100)"

// App state
Brick.AppState.isDebug               // Debug mode check
Brick.AppState.state                 // .debug / .testFlight / .appStore
```

##### CurrentLanguage

```swift
let language = Brick.Language.currentLanguage  // "en", "zh", etc.
```

##### ViewLifeCycle

```swift
view.onFirstAppear {
    print("First appeared!")
}

view.onWillDisappear {
    print("Will disappear")
}

view.onDidDisappear {
    print("Did disappear")
}
```

##### Screen & Device

```swift
// Screen dimensions
Screen.width
Screen.height
Screen.safeArea
Screen.scale

// Device detection
Device.isIpad        // iPad check
Device.idiom          // .pad / .phone / .tv

// Window/ViewController
UIWindow.keyWindow
UIViewController.currentViewController()
UIViewController.currentNavigationController()
```

##### Adapter

```swift
// Zoom calculation (responsive design)
let size = 100.zoom()  // Auto scale based on screen width
let width = 375.zoom() // Convert from design width (375pt)

// Screen adaptation by width range
let value = 10.screen.width(0..<375, is: 10, zoomed: 8)

// Screen adaptation by screen inch
let height = 20.screen.inch(._6_1, is: 20, zoomed: 18)

// Screen adaptation by level (compact/regular/full)
let padding = 16.screen.level(.full, is: 20, zoomed: 16)

// Set custom zoom conversion
UIAdapter.Zoom.set { origin in
    return origin * (UIScreen.main.bounds.width / 375.0)
}
```

##### Image (ImageRepresentable)

```swift
// Resize image
let resized = image.resized(toWidth: 500)
let byHeight = image.resized(toHeight: 300)
let maxWidth = image.resized(toMaxWidth: 200)

// Get JPEG data
if let jpgData = image.jpegData(resizedToWidth: 1000, withCompressionQuality: 0.8) {
    // Use JPEG data
}

// Image format detection
let format = ImageFormat.get(from: data)

// iOS specific
image.copyToPasteboard()  // Copy to clipboard
image.saveToPhotos { error in }  // Save to album

// Tint color
let tinted = image.tinted(with: .red, blendMode: .sourceAtop)

// Rotate
let rotated = image.rotated(withRadians: .pi / 4)
```

##### BrickLog

```swift
// Static methods
Log.info("Info message")
Log.debug("Debug message")
Log.warning("Warning message")
Log.error("Error message")
Log.fault("Fault message")

// Instance methods
let logger = BrickLog.create(category: "MyLog")
logger.info("Custom log")
logger.error("Error: \(error)")
```

## Usage


## Install

### Swift Package Manager

Starting from Xcode 11, the Swift Package Manager is integrated, which is very convenient to use. Brick_SwiftUI also supports integration via Swift Package Manager.

Select `File > Swift Packages > Add Pacakage Dependency` in Xcode's menu bar, and enter in the search bar

`https://github.com/jackiehu/Brick_SwiftUI`, you can complete the integration

### Manual Install

Brick_SwiftUI also supports manual Install, just drag the Brick_SwiftUI folder in the Sources folder into the project that needs to be installed


## Author

jackiehu, 814030966@qq.com

## More tools to speed up APP development

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftBrick&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftLog&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftLog)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMesh&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNotification&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNotification)


## License

Brick_SwiftUI is available under the MIT license. See the LICENSE file for more info.
