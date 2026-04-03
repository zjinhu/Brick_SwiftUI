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
│   ├── GridIem++     # Grid item extensions
│   ├── String+       # String extensions
│   └── View+Geometry # View geometry extensions
├── Wrapped/          # View extensions via Brick<Wrapped> pattern
└── Tools/             # UI Components
    ├── Animation/     # Animation components
    ├── Blur/          # Blur effects (GlassBlurView, BlurView)
    ├── CarouselView/  # Carousel components
    ├── Date/          # Date utilities
    ├── Gestures/      # Gesture handlers
    ├── Keychain/      # Keychain utilities
    ├── Language/      # Language settings
    ├── List/          # List utilities
    ├── Loading/       # Loading overlays
    ├── Navigation/    # Navigation components
    ├── NavigationStack/ # Navigation stack (iOS 16- compatible)
    ├── OpenUrl/       # URL opening (OpenURL, Link, WebView, Safari)
    ├── Others/        # Other components
    ├── Page/          # Page components
    ├── Picker/        # Picker components
    ├── Presentation/  # Presentation controls
    ├── Progress/      # Progress indicators
    ├── Refresh/       # Pull-to-refresh
    ├── ScrollStack/   # Scrollable stacks
    ├── ScrollView/    # ScrollView helpers
    ├── Segment/       # Segment picker
    ├── Shape/         # Custom shapes
    ├── TTextField/     # Text field
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
"Hello". localized()
"123".toInt()
```

### View+Geometry
```swift
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { old, new in }
```

## Utilities

Core utility tools in `Sources/Brick/Utilities/`:

- `Brick` - Core wrapper type
- `SFSymbols` - SF Symbol type-safe wrapper
- `Keyboard` - Keyboard manager
- `Color+` - Color extensions
- `UIColor++` - UIColor extensions
- `UIView++` - UIView extensions
- `Screen++` - Screen utilities
- `CGSize++` - CGSize extensions
- `Image+` - Image extensions
- `Adapter` - Responsive design adapter
- `CurrentLanguage` - Language detection
- `Application` - App info
- `BrickLog` - Logging utilities
- `ViewLifeCycle` - View lifecycle hooks

## Adding Bilingual Comments

When adding Chinese/English bilingual comments to Swift files:

### Format
```swift
/// 功能描述/Function description
/// - Parameter param: 参数描述/Parameter description
/// - Returns: 返回值描述/Return value description
```

### Key Patterns

1. **Public Types and Structs**
```swift
/// 组件名称/Component name
/// 组件功能描述/Component function description
public struct MyComponent: View { }
```

2. **Initializers**
```swift
/// 初始化方法/Initialize method
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

4. **Methods/Modifiers**
```swift
/// 方法描述/Method description
/// - Parameter param: 参数描述/Parameter description
/// - Returns: 返回描述/Return description
public func myMethod(param: Type) -> some View { }
```

## Updating README

### Components Table Format

Add new components to the "Tools - UI Components" table:

```markdown
| **ComponentName** | Description | Usage |
|-------------------|-------------|-------|
```

### API Usage Section Format

Add detailed API documentation:

```markdown
##### ComponentName

```swift
// Basic usage
ComponentName()

// With options
ComponentName(option: value)

// Custom configuration
ComponentName()
    .modifier()
```
```

## Common Tasks

### 1. Process a New Folder
1. List all Swift files in the folder
2. Read each file to understand its structure
3. Add bilingual comments to all public APIs
4. Add the component to README table
5. Add API usage examples to README

### 2. Update Existing Comments
1. Search for the file in the codebase
2. Read the current implementation
3. Add missing bilingual comments
4. Ensure documentation matches code

### 3. Add New Component to README
1. Find the "Tools - UI Components" section
2. Add component to the table
3. Add detailed API usage section after existing components

## Key Files

- `README.md` - English documentation
- `README_ZH.md` - Chinese documentation
- `Sources/Brick/Tools/` - All component source files

## Tools/Commands

- Swift files: `Sources/Brick/Tools/**/*/*.swift`
- Documentation: Search for specific component names in README files