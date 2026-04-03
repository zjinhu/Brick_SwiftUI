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

- [x] **View++** - View extensions: `.then()`, `.hidden()`, `.offset()`, `.fill()`, `.fit()`, `.hideKeyboard()`, `.tintColor()`
- [x] **ForEach++** - ForEach enhancement: index access, enumeration support, `.interleave()`, `.interdivided()`, `.interspaced()`
- [x] **View+Geometry** - Bind view geometry: `bindSafeAreaInsets`, `bindSize`
- [x] **View+Haptic** - Haptic feedback: `HapticButton`, tap/change/selection feedback
- [x] **View+Frame** - Frame extensions: `.minWidth()`, `.maxWidth()`, `.height()`, `.width()`, `.readHeight()`, `.readWidth()`, `.squareFrame()`
- [x] **View+Mask** - Mask extensions: `.mask()`, `.masking()`, `.reverseMask()`
- [x] **View+Background** - Background extensions: `PassthroughView`, `.backgroundFill()`
- [x] **Image++** - Image extensions: `.symbol()`, `.resized()`, `.sizeToFit()`
- [x] **View+Conditionals** - Conditional views: `.enabled()`, `.hidden(if)`, `.visible(if)`
- [x] **Text++** - Text extensions
- [x] **Label++** - Label extensions
- [x] **List++** - List extensions
- [x] **Section++** - Section extensions
- [x] **NavigationLink++** - NavigationLink extensions
- [x] **Shape++** - Shape extensions
- [x] **Spacer++** - Spacer extensions
- [x] **Menu++** - Menu extensions
- [x] **Angle++** - Angle extensions
- [x] **Collection++** - Collection extensions
- [x] **URL++** - URL extensions
- [x] **String++** - String extensions
- [x] **Task+** - Task extensions
- [x] **GridItem++** - GridItem extensions

### Tools - UI Components

- [x] **NavigationStack** - Navigation stack (iOS 16-)
- [x] **Toast** - Toast messages with position (top/bottom), animation types (fade/slide/scale)
- [x] **ListPicker** - Generic list picker with sections, single/multi selection
- [x] **TTextField** - Custom styled text field with title, placeholder, error states
- [x] **CarouselView** - Horizontal carousel with scaling, wrapping, auto-scroll
- [x] **FlipView** - 3D flip card view
- [x] **OpenUrl** - URL opening tools
- [x] **WebView** - WebView component
- [x] **Presentation** - Presentation controls: DragIndicator, Detents, InteractiveDismiss, ContentInteraction, CornerRadius
- [x] **TextEditors** - TextEditor style extensions
- [x] **UnderLineText** - Underline text input

### Utilities - Core Utilities

- [x] **Brick** - Core wrapper type `Brick<Wrapped>`
- [x] **SFSymbols** - SF Symbol type-safe wrapper (V1-V7)
- [x] **Keyboard** - Keyboard manager, track keyboard height
- [x] **Color+** - Color extensions, Hex init, dynamic colors, random colors
- [x] **UIColor++** - UIColor extensions
- [x] **UIView++** - UIView extensions
- [x] **Screen++** - Screen size extensions
- [x] **CGSize++** - CGSize extensions
- [x] **Image+** - Image extensions
- [x] **Adapter** - Adapter utilities
- [x] **CurrentLanguage** - Current language detection
- [x] **Application** - Application info
- [x] **BrickLog** - Logging utilities
- [x] **ViewLifeCycle** - View lifecycle: onFirstAppear, didDisappear, willDisappear

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
