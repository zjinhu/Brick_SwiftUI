# Brick_SwiftUI

[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 14.0+](https://img.shields.io/badge/Xcode-14.0%2B-blue.svg)
![iOS 14.0+](https://img.shields.io/badge/iOS-14.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)
![SwiftUI 3.0+](https://img.shields.io/badge/SwiftUI-3.0%2B-orange.svg)

### SwiftUI APP 加速开发工具包

此项目与 [Gitee](https://gitee.com/zjinhu/brick) 相关联。如果你觉得在 SPM 中引入 GitHub 地址较慢，可以使用 Gitee。

内置多种辅助开发工具，iOS15 新增的 API 均已兼容 iOS14，具体功能用法请查看 demo

| ![](Image/1.png) | ![](Image/2.png) |
| ---------------- | ---------------- |
|                  |                  |

1.0.0 之前版本支持 iOS14，1.0.0 及之后版本使用 iOS16+Swift6.0

### Wrapped - View 扩展包装器

通过 `Brick<Wrapped>` 模式为 View 添加功能，使用 `view.ss.xxx` 调用

```swift
import Brick
// 使用方式
view.ss.tabBar(.hidden)
view.ss.onChange(of: value) { newValue in }
```

| 功能 | 说明 | 用法 |
|------|------|------|
| **TabbarVisible** | 控制 TabBar 显示/隐藏，支持动画 | `view.ss.tabBar(.hidden)` |
| **AppStore** | 生成 App Store 链接并展示应用推广页面 | `view.ss.showStoreProduct(appID: "123")` |
| **OnChange** | 统一的 onChange 处理，兼容 iOS 14-17 | `view.ss.onChange(of: value) { newValue in }` |
| **ShareSheet** | 自定义分享面板 | `ShareSheetView(activityItems: [...])` |
| **Checkmark** | 自定义复选框 toggle style | `view.ss.checkmark(.visible)` / `Toggle("Check", isOn: $bool).toggleStyle(.checkmark)` |
| **Geometry** | 几何变化检测与视觉特效 | `view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { old, new in }` |
| **Badge** | 徽章叠加系统 | `view.ss.badge { Text("99+") }` |
| **BottomSafeArea** | 自定义底部安全区域插入 | `view.ss.bottomSafeAreaInset { SomeView() }` |
| **Border** | 边框修饰器 | `view.ss.border(.red, cornerRadius: 8, lineWidth: 2)` |
| **Background** | 背景修饰器，隐藏 List/TextView 背景 | `view.ss.background { Color.blue }` / `view.ss.hideListBackground()` |
| **Alignment** | 调整视图对齐方式 | `view.ss.alignmentGuideAdjustment(anchor: .topLeading)` |
| **CustomBackButton** | 自定义导航返回按钮 | `view.ss.navigationCustomBackButton { Image(systemName: "chevron.left") }` |
| **Task** | 回退的 .task 修饰器 for iOS 14- | `view.ss.task { await doSomething() }` |
| **TabbarColor** | 设置 TabBar 背景色 | `view.ss.tabbarColor(.white)` |
| **Submit** | 表单提交处理，自定义键盘返回键 | `view.ss.onSubmit { submit() }` / `view.ss.submitLabel(.done)` |
| **SafeArea** | 基于安全区域的应用填充 | `view.ss.safeAreaPadding(16)` |
| **OnTapLocal** | 获取点击位置坐标 | `view.ss.onTapGesture { point in print(point) }` |
| **NavigationBarColor** | 设置导航栏背景色 | `view.ss.navigationBarColor(backgroundColor: .blue)` |
| **ListSpace** | 设置 List 分组间距 | `view.ss.listSectionSpace(20)` |
| **Hidden** | 条件视图隐藏，支持过渡动画 | `view.ss.hidden(isHidden, transition: .opacity)` |
| **PushTransition** | 边缘推送/弹出过渡 (iOS 16+) | `AnyTransition.ss.push(from: .leading)` |
| **Overlay** | 叠加修饰器 | `view.ss.overlay { SomeView() }` |
| **Section** | 回退的 Section 容器 for iOS 14- | `Brick.Section("Title") { content }` |
| **ProposedViewSize** | 提议视图尺寸结构体 | `ProposedViewSize.zero` / `.infinity` / `.unspecified` |
| **RequestReview** | 应用商店评价请求 | `@Environment(\.requestReview) var requestReview` |
| **Shadow** | 阴影修饰器 | `view.ss.shadow(color: .black, x: 0, y: 2, blur: 4)` |
| **NavigationTitle** | 导航标题与显示模式控制 | `view.ss.navigationTitle("Title", displayMode: .large)` |
| **Mask** | 反向蒙版，用于徽章效果 | `view.ss.invertedMask { Circle() }` |
| **Corner** | 特定圆角设置 | `view.ss.cornerRadius(10, corners: [.topLeft, .topRight])` |
| **Alert** | UIAlertController 按钮色调自定义 | `.alert("Title").ss.alertButtonTint(.white)` |

#### Wrapped 详细 API 用法

##### TabbarVisible - TabBar 可见性控制

```swift
// 控制 TabBar 显示/隐藏
view.ss.tabBar(.hidden)  // 隐藏 TabBar
view.ss.tabBar(.visible) // 显示 TabBar
```

##### OnChange - 值变化监听

```swift
// iOS 14-17 兼容的 onChange
view.ss.onChange(of: count) { newValue in
    print("New value: \(newValue)")
}

// 带初始值回调 (iOS 17+)
view.ss.onChange(of: value, initial: true) { oldValue, newValue in
    print("Changed from \(oldValue) to \(newValue)")
}

// 无参数闭包
view.ss.onChange(of: flag) {
    print("Flag changed")
}
```

##### Geometry - 几何变化检测

```swift
// 监听视图尺寸变化
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { oldSize, newSize in
    print("Size changed: \(oldSize) -> \(newSize)")
}

// 仅获取新值
view.ss.onGeometryChange(for: CGSize.self, of: { $0.size }) { newSize in
    print("New size: \(newSize)")
}

// 视觉特效
view.ss.visualEffect { anyView, proxy in
    someView
        .frame(width: proxy.size.width)
}
```

##### Badge - 徽章

```swift
// 基本徽章
view.ss.badge {
    Text("99+")
        .font(.caption)
        .foregroundColor(.white)
        .padding(4)
        .background(Color.red)
        .clipShape(Circle())
}

// 自定义配置
view.ss.badge(
    alignment: .topTrailing,
    anchor: UnitPoint(x: 0.3, y: 0.3),
    scale: 1.2,
    inset: 8
) {
    redCircle
}
```

##### Border - 边框

```swift
// 圆角矩形边框
view.ss.border(Color.blue, cornerRadius: 12, lineWidth: 2)

// 胶囊边框
view.ss.borderCapsule(Color.green, lineWidth: 1)

// 自定义形状边框
view.ss.border(LinearGradient(...), width: 3, cornerRadius: 8)
```

##### Task - 异步任务 (iOS 14-)

```swift
// 基础异步任务
view.ss.task {
    let data = await fetchData()
    print(data)
}

// 带优先级的任务
view.ss.task(priority: .background) {
    await heavyWork()
}

// 基于 ID 取消的任务 (值变化时重新执行)
view.ss.task(id: itemId) {
    await fetchItem(itemId)
}
```

##### Submit - 表单提交

```swift
// 提交动作
TextField("Enter text", text: $text)
    .ss.onSubmit {
        submitForm()
    }

// 提交标签 (键盘返回键)
TextField("Username", text: $username)
    .ss.submitLabel(.next)

TextField("Password", text: $password)
    .ss.submitLabel(.done)
```

##### SafeArea - 安全区域填充

```swift
// 统一填充
view.ss.safeAreaPadding(16)

// 指定边填充
view.ss.safeAreaPadding(.horizontal, 20)

// 使用 EdgeInsets
view.ss.safeAreaPadding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
```

##### Hidden - 条件隐藏

```swift
// 简单隐藏
view.ss.hidden(isLoading)

// 带过渡动画
view.ss.hidden(isHidden, transition: .slide)
view.ss.hidden(isHidden, transition: .scale)
view.ss.hidden(isHidden, transition: .opacity)
```

##### Corner - 特定圆角

```swift
import UIKit

// 仅顶部圆角
view.ss.cornerRadius(10, corners: [.topLeft, .topRight])

// 仅底部圆角
view.ss.cornerRadius(10, corners: [.bottomLeft, .bottomRight])

// 仅左上角
view.ss.cornerRadius(10, corners: [.topLeft])
```

##### Shadow - 阴影

```swift
view.ss.shadow(color: .black.opacity(0.2), x: 0, y: 4, blur: 8)
```

##### Checkmark - 复选框

```swift
// 视图修饰器
view.ss.checkmark(.visible)

// Toggle 样式
Toggle(" Agree to terms", isOn: $agreed)
    .toggleStyle(.checkmark)
```

### SwiftUI - SwiftUI 类型扩展

提供便捷功能的 SwiftUI 类型扩展。

| 功能 | 描述 | 用法 |
|------|------|------|
| **View++** | View 扩展: `.then()`, `.hidden()`, `.offset()`, `.fill()`, `.fit()`, `.hideKeyboard()` | `view.then { $0.padding() }` |
| **ForEach++** | ForEach 增强: 索引访问、`.interleave()`, `.interdivided()`, `.interspaced()` | `ForEach(items) { item in }` |
| **View+Geometry** | 绑定视图几何: `bindSafeAreaInsets`, `bindSize` | `view.bindSize($size)` |
| **View+Haptic** | 触觉反馈: `HapticButton`, 点击/变更/选择反馈 | `.hapticFeedback(.success)` |
| **View+Frame** | 框架扩展: `.minWidth()`, `.maxWidth()`, `.height()`, `.readHeight()` | `.minWidth(100)` |
| **View+Mask** | 蒙版扩展: `.mask()`, `.masking()`, `.reverseMask()` | `.reverseMask { Circle() }` |
| **View+Background** | 背景扩展: `PassthroughView`, `.backgroundFill()` | `.backgroundFill(Color.blue)` |
| **Image++** | Image 扩展: `.symbol()`, `.resized()`, `.sizeToFit()` | `Image(systemName: "heart").symbol(...)` |
| **View+Conditionals** | 条件视图: `.enabled()`, `.hidden(if)`, `.visible(if)` | `.hidden(if: isHidden)` |
| **Text++** | Text 扩展 | `Text("Hello").bold()` |
| **Label++** | Label 扩展 | `Label("标题", systemImage: "star")` |
| **List++** | List 扩展 | `List { ... }.listStyle(.insetGrouped)` |
| **Section++** | Section 扩展 | `Section("标题") { ... }` |
| **NavigationLink++** | NavigationLink 扩展 | `NavigationLink(destination: View)` |
| **Shape++** | Shape 扩展 | `Circle()`, `RoundedRectangle()` |
| **Spacer++** | Spacer 扩展 | `Spacer().frame(height: 10)` |
| **Menu++** | Menu 扩展 | `Menu { ... }` |
| **Angle++** | Angle 扩展 | `Angle(degrees: 45)` |
| **Collection++** | Collection 扩展 | `[1,2,3].safeSubscript(0)` |
| **URL++** | URL 扩展 | `URL(string: "...")` |
| **String++** | String 扩展 | `"hello".localized` |
| **Task+** | Task 扩展 | `Task.sleep(1000000000)` |
| **GridItem++** | GridItem 扩展 | `GridItem(.flexible())` |

### Tools - UI 组件

预构建的 UI 组件，支持快速开发。

| 功能 | 描述 | 用法 |
|------|------|------|
| **NavigationStack** | 导航栈 (iOS 16-) | `NavigationStack { ... }` |
| **Toast** | 提示消息，支持位置 (top/bottom) 和动画类型 | `Toast.show("消息")` |
| **ListPicker** | 通用列表选择器，支持分区、单选/多选 | `ListPicker(selection: $value, items: [])` |
| **TTextField** | 自定义样式文本框，支持标题、占位符、错误状态 | `TTextField(title: "名称", text: $text)` |
| **CarouselView** | 水平轮播，支持缩放、自动滚动 | `CarouselView(items: [])` |
| **FlipView** | 3D 翻转卡片视图 | `FlipView(front: View, back: View)` |
| **OpenUrl** | URL 打开工具 | `OpenURL(url)` |
| **WebView** | WebView 组件 | `WebView(url: url)` |
| **Presentation** | 演示控件: DragIndicator, Detents, CornerRadius | `presentationDetents([.medium, .large])` |
| **TextEditors** | TextEditor 样式扩展 | `TextEditor(text: $text).style(...)` |
| **UnderLineText** | 下划线文本输入 | `UnderLineText(text: $text)` |

### Utilities - 核心工具

核心工具为应用开发提供基础功能支持。

| 功能 | 描述 | 用法 |
|------|------|------|
| **Brick** | 核心包装类型 `Brick<Wrapped>`，支持 `view.ss.xxx` 语法 | `view.ss.tabBar(.hidden)` |
| **SFSymbols** | SF Symbol 类型安全封装 (V1-V7) | `Image(systemName: SFSymbols.V1.heart)` |
| **Keyboard** | 键盘管理器，跟踪键盘高度 | `KeyboardManager.shared.keyboardHeight` |
| **Color+** | 颜色扩展: Hex 初始化、动态颜色、随机颜色 | `Color(hex: "#FF5733")` |
| **UIColor++** | UIColor 扩展: Hex 初始化、RGB 初始化、动态颜色 | `UIColor(hex: 0xFF5733)` |
| **UIView++** | UIView/NSView 扩展: parentController、allSubviews() | `view.allSubviews()` |
| **Screen++** | 屏幕工具: 安全区域、尺寸、设备检测 | `Screen.width`, `Screen.safeArea` |
| **CGSize++** | CGSize 扩展: greatestFiniteSize、最小/最大维度 | `CGSize.greatestFiniteSize` |
| **Image+** | 图片扩展: 缩放、着色、旋转、保存到相册 | `image.resized(toWidth: 500)` |
| **Adapter** | 响应式设计适配器，缩放计算 | `100.zoom()`, `10.screen.width(...)` |
| **CurrentLanguage** | 当前语言检测 | `Brick.Language.currentLanguage` |
| **Application** | 应用信息: appName、version、buildNumber、appState | `Brick.Application.appName` |
| **BrickLog** | 日志: debug、info、warning、error、fault | `Log.info("消息")` |
| **ViewLifeCycle** | 视图生命周期: onFirstAppear、onDidDisappear、onWillDisappear | `view.onFirstAppear { }` |

#### Utilities 详细 API

##### BrickLog

```swift
// 静态方法
Log.info("信息消息")
Log.debug("调试消息")
Log.warning("警告消息")
Log.error("错误消息")
Log.fault("故障消息")

// 实例方法
let logger = BrickLog.create(category: "MyLog")
logger.info("自定义日志")
logger.error("错误: \(error)")
```

##### Color

```swift
// Hex 初始化
Color(hex: 0xFF5733)           // UInt64
Color(hex: "#FF5733")           // String
Color.hex(0xFF5733)             // 静态方法

// 动态颜色 (浅色/深色)
Color.dynamic(light: "#FFFFFF", dark: "#000000")

// 随机颜色
Color.random()
Color.random(in: 0.5...1.0, randomOpacity: true)
```

##### Keyboard

```swift
@StateObject private var keyboardManager = KeyboardManager()

var body: some View {
    VStack {
        Text("键盘高度: \(keyboardManager.keyboardHeight)")
    }
    .onAppear {
        // 隐藏键盘
        KeyboardManager.hideKeyboard()
    }
}
```

##### Application

```swift
// 应用信息
Brick.Application.appName           // 应用名称
Brick.Application.appBundleID       // Bundle ID
Brick.Application.versionNumber      // 版本号 (如 "1.0.0")
Brick.Application.buildNumber        // 构建号
Brick.Application.completeAppVersion // "1.0.0 (100)"

// 应用状态
Brick.AppState.isDebug               // 调试模式检测
Brick.AppState.state                 // .debug / .testFlight / .appStore
```

##### CurrentLanguage

```swift
let language = Brick.Language.currentLanguage  // "en", "zh" 等
```

##### ViewLifeCycle

```swift
view.onFirstAppear {
    print("首次出现!")
}

view.onWillDisappear {
    print("即将消失")
}

view.onDidDisappear {
    print("已消失")
}
```

##### Screen & Device

```swift
// 屏幕尺寸
Screen.width
Screen.height
Screen.safeArea
Screen.scale

// 设备检测
Device.isIpad        // iPad 检测
Device.idiom          // .pad / .phone / .tv

// 窗口/视图控制器
UIWindow.keyWindow
UIViewController.currentViewController()
UIViewController.currentNavigationController()
```

##### Adapter

```swift
// 缩放计算 (响应式设计)
let size = 100.zoom()  // 根据屏幕宽度自动缩放
let width = 375.zoom() // 从设计宽度转换 (375pt)

// 按屏幕宽度范围适配
let value = 10.screen.width(0..<375, is: 10, zoomed: 8)

// 按屏幕英寸适配
let height = 20.screen.inch(._6_1, is: 20, zoomed: 18)

// 按屏幕级别适配 (compact/regular/full)
let padding = 16.screen.level(.full, is: 20, zoomed: 16)

// 设置自定义缩放转换
UIAdapter.Zoom.set { origin in
    return origin * (UIScreen.main.bounds.width / 375.0)
}
```

##### Image (ImageRepresentable)

```swift
// 缩放图像
let resized = image.resized(toWidth: 500)
let byHeight = image.resized(toHeight: 300)
let maxWidth = image.resized(toMaxWidth: 200)

// 获取 JPEG 数据
if let jpgData = image.jpegData(resizedToWidth: 1000, withCompressionQuality: 0.8) {
    // 使用 JPEG 数据
}

// 图像格式检测
let format = ImageFormat.get(from: data)

// iOS 特有功能
image.copyToPasteboard()  // 复制到剪贴板
image.saveToPhotos { error in }  // 保存到相册

// 着色
let tinted = image.tinted(with: .red, blendMode: .sourceAtop)

// 旋转
let rotated = image.rotated(withRadians: .pi / 4)
```

##### BrickLog

```swift
// 静态方法
Log.info("信息消息")
Log.debug("调试消息")
Log.warning("警告消息")
Log.error("错误消息")
Log.fault("故障消息")

// 实例方法
let logger = BrickLog.create(category: "MyLog")
logger.info("自定义日志")
logger.error("错误: \(error)")
```

## 使用方法


## 安装

### Swift Package Manager

从 Xcode 11 开始，Swift Package Manager 已集成，使用非常方便。Brick_SwiftUI 也支持通过 Swift Package Manager 集成。

在 Xcode 菜单栏中选择 `File > Swift Packages > Add Package Dependency`，在搜索栏中输入

`https://github.com/jackiehu/Brick_SwiftUI`，即可完成集成

### 手动安装

Brick_SwiftUI 也支持手动安装，只需将 Sources 文件夹中的 Brick_SwiftUI 文件夹拖入需要安装的项目即可


## 作者

jackiehu, 814030966@qq.com

## 更多加速 APP 开发的工具

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMediator&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftBrick&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftLog&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftLog)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftMesh&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats.vercel.app/api/pin/?username=jackiehu&repo=SwiftNotification&theme=radical&locale=cn)](https://github.com/jackiehu/SwiftNotification)


## 许可证

Brick_SwiftUI 基于 MIT 许可证发布。详细信息请查看 LICENSE 文件。
