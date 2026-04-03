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

### Tools - UI Components

Pre-built UI components for rapid development.

| Feature | Description | Usage |
|---------|-------------|-------|
| **NavigationStack** | Navigation stack (iOS 16-) | `NavigationStack { ... }` |
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
