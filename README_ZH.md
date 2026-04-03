# Brick_SwiftUI

[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 14.0+](https://img.shields.io/badge/Xcode-14.0%2B-blue.svg)
![iOS 16.0+](https://img.shields.io/badge/iOS-16.0%2B-blue.svg)
![Swift 5.0+](https://img.shields.io/badge/Swift-5.0%2B-orange.svg)
![SwiftUI 3.0+](https://img.shields.io/badge/SwiftUI-3.0%2B-orange.svg)

### SwiftUI APP 加速开发工具包

此项目与 [Gitee](https://gitee.com/zjinhu/brick) 相关联。如果你觉得在 SPM 中引入 GitHub 地址较慢，可以使用 Gitee。

内置多种辅助开发工具，iOS15 新增的 API 均已兼容 iOS14，具体功能用法请查看 demo

| ![](Image/1.png) | ![](Image/2.png) |
| ---------------- | ---------------- |
|                  |                  |

1.0.0 之前版本支持 iOS14，1.0.0 及之后版本使用 iOS16+Swift6.0

---

## 🤖 AI 开发指南

BrickKit 提供了完整的 `AGENTS.md` 文件，作为 AI 开发工具（Cursor、opencode、GitHub Copilot 等）的 Skills 参考。该指南帮助 AI 助手理解库的结构并生成正确的代码。

### 如何与 AI 工具配合使用

#### 1. Cursor / opencode / Claude Code

在使用 BrickKit 的项目中，AI 助手会自动读取 `AGENTS.md` 来：

- **理解库结构** - 所有组件的完整目录树
- **生成正确的代码** - 每个 API 的使用示例
- **添加双语注释** - 中英文注释格式指南
- **遵循规范** - `Brick<Wrapped>` 模式、命名约定等

#### 2. 将 AGENTS.md 作为上下文使用

确保 `AGENTS.md` 在项目根目录下。AI 工具会自动将其作为上下文读取：

```
YourProject/
├── AGENTS.md          ← AI Skills 参考（从 BrickKit 复制）
├── Package.swift
└── Sources/
```

或者在 AI 工具的配置中直接引用：

```json
// .cursorrules 或类似配置
{
  "contextFiles": ["path/to/BrickKit/AGENTS.md"]
}
```

#### 3. Prompt 示例

让 AI 帮助使用 BrickKit 时：

```
使用 BrickKit，创建一个带下拉刷新和加载更多的列表。
```

AI 会参考 `AGENTS.md` 并生成：

```swift
List {
    ForEach(items) { item in
        Text(item.name)
    }
    LoadMoreView { loadMoreItems() }
}
.emptyPlaceholder(items) {
    Text("暂无数据")
}
.enableRefresh(true)
.onRefresh { refreshItems() }
```

#### 4. AGENTS.md 包含的内容

| 章节 | 内容 |
|------|------|
| **目录结构** | SwiftUI/、Wrapped/、Utilities/、Tools/ 的完整文件树 |
| **SwiftUI Extensions** | 24 个 SwiftUI 扩展的使用示例 |
| **Wrapped 用法** | 30 个 Wrapped 组件示例 (`view.ss.xxx`) |
| **Utilities** | 核心工具（SFSymbols、Keyboard、Adapter 等） |
| **Tools 用法** | 27 个 Tools 文件夹示例（Toast、Loading、Picker 等） |
| **注释指南** | 双语注释格式规范 |

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

#### SwiftUI 详细 API 用法

##### View++ (View 扩展)

```swift
// 链式调用视图修改
view.then { $0.padding() }
    .then { $0.background(Color.blue) }

// 条件隐藏
view.hidden(isHidden)

// 偏移辅助方法
view.offset(point)
view.offset(length)
view.inset(length)

// 填充/适应父视图
view.fill(alignment: .center)
view.fit()

// 过渡效果
view.transition(.scale)
view.asymmetricTransition(insertion: .opacity, removal: .move(edge: .leading))

// 类型擦除
view.eraseToAnyView()
view.any()

// 隐藏键盘 (iOS)
view.hideKeyboard()

// 条件点击手势
view.onTapGesture(count: 2, disabled: isDisabled) {
    // 处理点击
}

// 填充父视图
view.fill(alignment: .center)

// 适应父视图 (保持宽高比)
view.fit()

// 设置着色颜色
view.tintColor(.red)

// 背景点击手势
view.onTapGestureOnBackground {
    // 处理背景点击
}
```

##### ForEach++ (ForEach 增强)

```swift
// 带索引访问
ForEach(items, id: \.id) { index, item in
    Text("\(index): \(item.name)")
}

// 插入分隔符
ForEach(items) { item in
    Text(item.name)
}.interleave(with: Divider())

// 插入分割线
ForEach(items) { item in
    Text(item.name)
}.interdivided()

// 插入间距
ForEach(items) { item in
    Text(item.name)
}.interspaced()
```

##### View+Geometry (视图几何)

```swift
@State private var size: CGSize = .zero
@State private var safeArea: EdgeInsets = .zero

view.bindSize(to: $size)
view.bindSafeAreaInsets(to: $safeArea)
```

##### View+Haptic (触觉反馈)

```swift
// 触觉按钮
HapticButton {
    print("tapped")
} label: {
    Text("点击我")
}

// 触觉反馈
hapticFeedback()
hapticFeedback(type: .success)
hapticFeedback(type: .medium)

// 视图触觉修饰器
view.haptics(onChangeOf: value, type: .success)
view.haptics(when: status, equalsTo: "success", type: .warning)
view.haptics(onChangeOf: count, type: .light)
view.triggersHapticFeedbackWhenAppear()
```

##### View+Frame (视图框架)

```swift
// 最小/最大宽高
view.minWidth(100)
view.maxWidth(200)
view.minHeight(50)
view.maxHeight(150)

// 宽高设置
view.width(100)
view.height(50)

// 相对尺寸
view.relativeWidth(0.5)
view.relativeHeight(0.3)
view.relativeSize(width: 0.5, height: 0.3)

// 读取尺寸
view.readHeight { height in print(height) }
view.readWidth { width in print(width) }

// 正方形框架
view.squareFrame()
view.squareFrame(sideLength: 100)

// 理想框架
view.idealFrame(width: 100, height: 50)
```

##### View+Mask (视图蒙版)

```swift
// 蒙版
view.mask(Circle())

// 反向蒙版
view.masking {
    Circle()
}

// 反向蒙版 (用于徽章效果)
view.reverseMask(alignment: .topTrailing) {
    Circle()
        .frame(width: 20, height: 20)
}
```

##### View+Background (视图背景)

```swift
// 背景
view.background(Color.red)
view.background {
    Image("bg")
}

// 填充背景 (忽略安全区域)
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
// 带配置的符号图标
Image(systemName: "heart")
    .symbol(variableColor: .blue)
    .symbolRenderingMode(.hierarchical)

// 调整图像大小
Image(systemName: "heart")
    .resized(toWidth: 100)
    .resized(toHeight: 50)

// 适应尺寸
image.sizeToFit()

// 异步加载图像
AsyncImage(url: url)
    .loadAsync()
```

##### View+Conditionals

```swift
// 启用/禁用视图
view.enabled(isEnabled)
view.enabled(isEnabled, removeFromHierarchy: true)

// 条件可见性
view.hidden(if: isHidden)
view.visible(if: isVisible)

// 条件修饰器
view.modifier(if: shouldApply) {
    SomeModifier()
}
```

##### Text++

```swift
// 文本样式
Text("Hello")
    .bold()
    .italic()
    .underline()
    .strikethrough()
    .monospaced()
    .smallCaps()
    .textCase(.uppercase)
    .textCase(.lowercase)

// 字间距
Text("Hello")
    .tracking(2)
    .tracking(-0.5)
```

##### Label++

```swift
// 带图标的标签
Label("标题", systemImage: "star")
Label {
    Text("内容")
} icon: {
    Image(systemName: "star")
}
```

##### List++

```swift
// 带样式的列表
List {
    // 内容
}
.listStyle(.insetGrouped)
.listStyle(.plain)
.listStyle(.inset)
.listStyle(.sidebar)

// 列表行背景
.listRowBackground(Color.clear)
```

##### Section++

```swift
// 带标题的分区
Section("标题") {
    Text("内容")
}

// 带标题和脚注的分区
Section(header: Text("标题"), footer: Text("脚注")) {
    Text("内容")
}
```

##### NavigationLink++

```swift
// 推送导航
NavigationLink(destination: DetailView()) {
    Text("跳转到详情")
}

// 基于值的导航
NavigationLink(value: item) {
    Text(item.name)
}
.navigationDestination(for: Item.self) { item in
    DetailView(item: item)
}
```

##### Shape++

```swift
// 圆角矩形
RoundedRectangle(cornerRadius: 10)
RoundedRectangle(cornerRadius: 10, style: .continuous)

// 胶囊形状
Capsule()
Capsule(style: .continuous)

// 自定义形状
Rectangle()
Circle()
Ellipse()
```

##### Spacer++

```swift
// 带最小长度的 Spacer
Spacer(minLength: 20)

// 带框架的 Spacer
Spacer()
    .frame(height: 10)
```

##### Menu++

```swift
// 基础菜单
Menu("操作") {
    Button("操作1") { }
    Button("操作2") { }
}

// 带标签的菜单
Menu {
    Button("编辑") { }
    Button("删除") { }
} label: {
    Image(systemName: "ellipsis.circle")
}
```

##### Angle++

```swift
// 从度数创建角度
Angle(degrees: 45)

// 从弧度创建角度
Angle(radians: .pi / 4)

// 旋转内容
content
    .rotationEffect(Angle(degrees: 45))
```

##### Collection++

```swift
// 安全下标
let item = array[safe: 0]  // 超出范围时返回 nil

// 第一个/最后一个
array[safe: \.first]
array[safe: \.last]

// 边界安全访问
array[safe: 0...5]
array[safe: 0..<5]
```

##### URL++

```swift
// 带查询参数的 URL
var components = URL(string: "https://example.com")
components?.queryItems = [
    URLQueryItem(name: "key", value: "value")
]

// 检查 URL 有效性
url?.isValid
```

##### String++

```swift
// 大小写转换
"hello".uppercasedFirst()  // "Hello"
"hello".lowercasedFirst()  // "hello"
"hello_world".camelcased()  // "helloWorld"
"HelloWorld".snakecased()  // "hello_world"
"hello world".titlecased() // "Hello World"

// URL 编码
"hello world".urlEscaped()  // "hello%20world"

// 换行处理
"line1\nline2".lines()  // ["line1", "line2"]

// 空白处理
"  hello  world  ".trimmed()  // "hello world"

// 模式替换
"hello".replacing("l", with: "r")  // "herro"

// 验证
"https://example.com".isValidUrl  // true
"   ".isBlank  // true

// 前缀/后缀移除
"hello world".droppingPrefix("hello ")  // "world"
"hello world".droppingSuffix(" world")  // "hello"

// 获取最后几个字符
"hello".take(last: 3)  // "llo"

// 随机字符串
String.random(length: 10)

// 截断
"Hello World".truncate(5)  // "He..."
"Hello World".truncate(5, position: .head)  // "...rld"
"Hello World".truncate(5, position: .middle)  // "He...ld"

// 空/空白时返回 nil
"".nilIfEmpty  // nil
"   ".nilIfBlank  // nil
```

##### Task+

```swift
// 睡眠
try? await Task.sleep(1_000_000_000) // 1秒

// 带超时的任务
try? await Task.timeout(after: 1.0) {
    await someWork()
}
```

##### GridItem++

```swift
// 弹性网格项
GridItem(.flexible())
GridItem(.flexible(spacing: 10))
GridItem(.flexible(spacing: 10, alignment: .leading))

// 固定网格项
GridItem(.fixed(100))
GridItem.fixed(100)

// 自适应网格项
GridItem.adaptive(minimum: 50, maximum: 100)

// 网格项数组
[GridItem].fixed([100, 200, 100])
[GridItem].adaptive(minimum: 80, maximum: .infinity)
[GridItem].flexible(minimum: 50, maximum: 200)

// GridItem.Size
GridItem.Size.adaptive(100)
```

### Tools - UI 组件

预构建的 UI 组件，支持快速开发。

| 功能 | 描述 | 用法 |
|------|------|------|
| **NavigationStack** | 导航栈 (iOS 16-) + 导航API | `Brick.NavigationStack { ... }` / `Navigator.push()` |
| **Navigation** | 导航项、滑动返回、路径辅助 | `.navigationItem()` / `.regainSwipeBack()` |
| **Toast** | 提示消息，支持位置 (top/bottom) 和动画类型 | `Toast.show("消息")` |
| **ListPicker** | 通用列表选择器，支持分区、单选/多选 | `ListPicker(selection: $value, items: [])` |
| **TTextField** | 自定义样式文本框，支持标题、占位符、错误状态 | `TTextField(title: "名称", text: $text)` |
| **CarouselView** | 水平轮播，支持缩放、自动滚动 | `CarouselView(items: [])` |
| **FlipView** | 3D 翻转卡片视图 | `FlipView(front: View, back: View)` |
| **OpenUrl** | URL打开：OpenURL、Link、Safari、WebView | `Brick.Link("文本", destination: url)` / `WebView(url: url)` |
| **WebView** | WebView 组件 | `WebView(url: url)` |
| **Presentation** | 演示控件: DragIndicator, Detents, CornerRadius | `presentationDetents([.medium, .large])` |
| **TextEditors** | TextEditor 样式扩展 | `TextEditor(text: $text).style(...)` |
| **UnderLineText** | 下划线文本输入 | `UnderLineText(text: $text)` |
| **UIHostingConfiguration** | UIKit 单元格内容配置 | `UIHostingConfiguration { ... }` |
| **Loading** | 加载动画遮罩 + LoadingManager | `.loading(isPresented: $loading) { ... }` / `LoadingManager()` |
| **Keychain** | 钥匙串存储工具 | `KeychainService.shared.set(value, forKey: "key")` |
| **ScrollView** | ScrollView 辅助功能：指示器、键盘 dismissal、启用状态 | `.ss.scrollIndicators(.hidden)` |
| **ScrollStack** | 延迟加载的可滚动堆栈和网格 | `VScrollStack { ... }` / `HScrollStack { ... }` |
| **Gestures** | 手势按钮，支持按压、长按、双击、重复、滑动 | `GestureButton { ... }` |
| **Triangle** | 三角形形状 | `Triangle()` / `Triangle(inverted: true)` |
| **RoundedCorner** | 圆角形状 | `RoundedCorner(radius: 10)` |
| **CustomSegmentPicker** | 自定义分段选择器 | `CustomSegmentPicker(selection: $index, segments: [])` |
| **Others** | 杂项：FlipView、MarqueeText、RadioButton、OtpView、ExpandText等 | `FlipView(front: View, back: View)` |

#### Tools 详细 API 用法

##### Navigation

```swift
// 导航项自定义
NavigationView {
    ContentView()
}
.navigationItem(animated: true) { item in
    item.title = "我的标题"
}

// 隐藏返回按钮标题
NavigationView {
    ContentView()
}
.hiddenBackButtonTitle()

// 恢复滑动返回手势
ContentView()
    .regainSwipeBack()

// 导航路径 (iOS 16+)
@StateObject var path = NavigatorPath()

path.path.push("新页面")
path.path.pop()
path.path.popTo(index: 0)
path.path.popToRoot()
```

##### NavigationStack

```swift
// 基础导航栈 (跨版本)
Brick.NavigationStack {
    VStack {
        Text("根视图")
    }
}

// 带类型化路径
@State var path: [MyScreen] = []

Brick.NavigationStack(path: $path) {
    ContentView()
}

// 使用 Navigator
@EnvironmentObject var navigator: Navigator<MyScreen>

// 推入页面
navigator.push(.detail)

// 返回页面
navigator.pop()        // 返回1页
navigator.pop(2)       // 返回2页
navigator.popToRoot()  // 返回根页面
navigator.popTo(index: 0)
navigator.popTo(where: { $0 == .home })

// 导航链接
Brick.NavigationLink("前往详情", value: MyScreen.detail)

// 导航目标
.navigationDestination(isPresented: $showDetail) {
    DetailView()
}

// 使用 SwiftUI NavigationStack 策略
.useNavigationStack(.whenAvailable)  // 或 .never
```

##### CarouselView

```swift
// 基础走马灯
CarouselView(items, id: \.id) { item in
    Image(item.imageURL)
        .resizable()
        .aspectRatio(contentMode: .fill)
}
.index($currentIndex)

// 自定义配置
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

// 自动滚动选项
CarouselAutoScroll.inactive        // 不自动滚动
CarouselAutoScroll.active(5)       // 每5秒自动滚动
CarouselAutoScroll.defaultActive  // 默认5秒
```

##### Page

```swift
// 基础分页滚动视图
@State private var currentPage = 0

PageScrollView(pageOutWidth: 50, pagePadding: 10) {
    ForEach(0..<10, id: \.self) { index in
        RoundedRectangle(cornerRadius: 20)
            .fill(.orange)
            .overlay {
                Text("页面 \(index)")
            }
    }
}
.frame(height: 228)

// 配合 PageIndicator 使用
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

##### Animation

```swift
// 动画完成回调
@State private var scale: CGFloat = 1.0

Button("动画") {
    withAnimation(.spring()) {
        scale = 1.5
    }
}
.onAnimationCompleted(for: scale) {
    // 动画完成时调用
    print("动画完成!")
}

// 带完成处理的动画
withAnimation(.easeInOut(duration: 0.5), after: 0.5, completion: {
    print("完成!")
}) {
    isAnimated.toggle()
}

// 延迟动画
withAnimation(.spring(), after: 1.0) {
    viewModel.update()
}

// 检查事务是否正在动画
let transaction = Transaction(animation: .default)
let isAnimated = transaction.isAnimated  // true

// 禁用动画
withoutAnimation {
    updateWithoutAnimation()
}
```

##### Blur

```swift
// 基础模糊视图 (iOS/tvOS)
BlurView()
    .frame(height: 200)

// 玻璃模糊效果 (iOS 15+)
GlassBlurView(removeAllFilters: false)
    .frame(height: 180)

// 自定义背景
GlassBlurView(removeAllFilters: true)
    .blur(radius: 5, opaque: true)
    .background(.black.opacity(0.8))
    .frame(height: 180)

// 玻璃拟态模糊效果
GlassmorphismBlurView()
    .frame(width: 300, height: 200)
```

##### Toast

```swift
// 基础Toast (CustomToast)
@State private var showToast = false

VStack {
    Button("显示Toast") {
        showToast = true
    }
}
.toast(isPresented: $showToast, position: .top, animation: .fade, duration: 2.0) {
    Text("你好世界")
        .padding()
        .background(Color.black.opacity(0.8))
        .foregroundColor(.white)
        .cornerRadius(10)
}

// AlertToast显示模式
@State private var showAlert = false

// 弹窗模式
.toast(isPresented: $showAlert, duration: 2) {
    AlertToast(
        displayMode: .alert,
        type: .systemImage("checkmark.circle.fill", .green),
        title: "成功",
        subTitle: "操作完成"
    )
}

// HUD模式
.toast(isPresented: $showHUD, duration: 2) {
    AlertToast(
        displayMode: .hud,
        type: .systemImage("star.fill", .orange),
        title: "加载中...",
        subTitle: "请稍候"
    )
}

// 横幅模式
.toast(isPresented: $showBanner, duration: 2) {
    AlertToast(
        displayMode: .banner(.slide),
        type: .systemImage("info.circle.fill", .blue),
        title: "新消息",
        subTitle: "您有一条新通知"
    )
}
```

##### ToastManager

```swift
// 基础ToastManager用法
@StateObject private var toastManager = ToastManager()

VStack {
    Button("显示Toast") {
        toastManager.showText("你好世界")
    }
}
.addToast(toastManager)

// 自定义配置
@StateObject private var customToast = ToastManager(position: .top)

customToast.duration = 5.0
customToast.padding = 20

Button("显示自定义Toast") {
    customToast.show {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text("成功!")
            .font(.headline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
.addToast(customToast)

// 手动关闭（带回调）
Button("显示后关闭") {
    toastManager.show {
        Text("3秒后自动关闭")
            .padding()
            .background(Color.black.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
    }
} onTap: {
    toastManager.dismiss {
        print("Toast已关闭!")
    }
}

// 不同位置
@StateObject private var topToast = ToastManager(position: .top)
@StateObject private var bottomToast = ToastManager(position: .bottom)

Button("顶部Toast") {
    topToast.showText("从顶部出现")
}
.addToast(topToast)

Button("底部Toast") {
    bottomToast.showText("从底部出现")
}
.addToast(bottomToast)

// MessageView自定义
toastManager.show {
    MessageView(text: "简单消息")
        .padding(15)
        .background(Color.blue.opacity(0.9))
        .cornerRadius(12)
}
```

##### OpenUrl

```swift
// OpenURL操作
@Environment(\.openURL) private var openURL

Button("打开URL") {
    if let url = URL(string: "https://example.com") {
        openURL(url)
    }
}

// 带完成处理
openURL(url) { accepted in
    print(accepted ? "打开成功" : "打开失败")
}

// 自定义URL处理
Text("访问 [示例](https://example.com)")
    .environment(\.openURL, Brick.OpenURLAction { url in
        return .handled
    })

// Safari浏览器
openURL(url) { _ in
    Brick.OpenURLAction.Result.safari(url)
}

// Safari带配置
openURL(url) { _ in
    Brick.OpenURLAction.Result.safari(url) { config in
        config.prefersReader = true
        config.dismissStyle = .done
        config.tintColor = .blue
    }
}

// Brick.Link
Brick.Link("访问网站", destination: URL(string: "https://example.com")!)

// WebView
WebView(url: URL(string: "https://example.com")!)
    .showProgress(true)
    .getWebViewObject($webView)
    .getWebViewState($webViewState)
    .clearBackgroundColor()
    .showRefreshControl(true)
    .onMessageHandler(name: "native") { message in
        print(message)
    }
```

##### NavigationStack

```swift
// 基础NavigationStack (iOS 14-15兼容)
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

// 不带path绑定（内部path管理）
Brick.NavigationStack {
    List {
        NavigationLink("详情", value: "detail1")
    }
    .navigationDestination(for: String.self) { value in
        DetailView(title: value)
    }
}

// 使用Navigator（编程式导航）
@EnvironmentObject var navigator: Navigator<String>

Button("推入详情") {
    navigator.push("newDetail")
}

Button("返回") {
    navigator.pop()
}

Button("返回根") {
    navigator.popToRoot()
}
```

##### OpenUrl

```swift
// OpenURL - 自定义URL打开操作
@Environment(\.openURL) var openURL

Button("打开网站") {
    if let url = URL(string: "https://www.example.com") {
        openURL(url)
    }
}

// 带完成回调
openURL(url) { accepted in
    print(accepted ? "成功" : "失败")
}

// 自定义URL处理器
Text("访问 [示例](https://www.example.com)")
    .environment(\.openURL, Brick.OpenURLAction { url in
        handleURL(url)
        return .handled
    })

// Link - URL链接组件
Brick.Link("查看条款", destination: URL(string: "https://www.example.com/TOS.html")!)

// 带自定义openURL
Brick.Link("访问网站", destination: URL(string: "https://www.example.com")!)
    .environment(\.openURL, Brick.OpenURLAction { url in
        print("打开 \(url)")
        return .handled
    })

// Safari - 在Safari中打开URL（使用SFSafariViewController）
Brick.OpenURLAction.Result.safari(url)

// 带自定义配置
Brick.OpenURLAction.Result.safari(url) { config in
    config.prefersReader = true
    config.barCollapsingEnabled = false
    config.dismissStyle = .close
    config.tintColor = .blue
}

// WebView - WKWebView组件
WebView(url: URL(string: "https://www.example.com")!)
    .showProgress(true)
    .setProgressColor(.green)
    .showRefreshControl(true)
    .clearBackgroundColor()
    .setCookies([cookie1, cookie2])
    .localStorageItem("值", forKey: "键")
    .getWebViewState($state)
    .getWebViewObject($webView)

// WebView带JS消息处理器
WebView(url: url)
    .onMessageHandler(name: "处理器名") { body in
        print("收到: \(body ?? "")")
    }

// 清理所有网页数据
WebView.Coordinator.cleanAllWebsiteDataStoreIfNeeded()
```

##### TTextField

```swift
// 基础用法
@State private var text = ""

TTextField(text: $text)
    .tTextFieldTitle("用户名")
    .tTextFieldPlaceHolderText("请输入用户名")
    .tTextFieldTextColor(.black)

// 错误状态
@State private var hasError = false
@State private var errorMessage = "输入无效"

TTextField(text: $text, error: $hasError, errorText: $errorMessage)
    .tTextFieldTitle("邮箱")
    .tTextFieldPlaceHolderText("请输入邮箱")

// 密码框
TTextField(text: $password)
    .tTextFieldSecure(true)

// 自定义样式
TTextField(text: $text)
    .tTextFieldTitleFont(.headline)
    .tTextFieldBackgroundColor(.white)
    .tTextFieldBorderColor(.gray)
    .tTextFieldErrorTextColor(.red)
    .tTextFieldFocusedBorderColor(.blue)
    .tTextFieldBorderType(.square)
    .tTextFieldBorderWidth(1)
    .tTextFieldCornerRadius(8)
    .tTextFieldHeight(44)

// 左侧/右侧视图
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

// 输入限制
TTextField(text: $text)
    .tTextFieldLimitCount(20)
    .tTextFieldTruncationMode(.tail)

// 禁用自动更正
TTextField(text: $text)
    .tTextFieldDisableAutoCorrection(true)
```

##### ListPicker

```swift
// 基础单选选择器
@State private var selectedItem: Item?

ListPicker(selection: $selectedItem, items: items) { item, isSelected in
    ListSelectItem(isSelected: isSelected) {
        Text(item.name)
    }
}

// 带分区
@State private var selected: Item?

ListPicker(
    sections: [
        ListPickerSection(title: "分区1", items: items1),
        ListPickerSection(title: "分区2", items: items2)
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

// 多选选择器
@State private var selectedItems: [Item] = []

ListMultiPicker(selection: $selectedItems, items: items) { item, isSelected in
    ListSelectItem(isSelected: isSelected) {
        Text(item.name)
    }
}

// 自定义指示器
ListSelectItem(isSelected: isSelected, selectIndicator: Image(systemName: "checkmark.circle.fill")) {
    Text("项目名称")
}

// 可选绑定回退
@State private var optionalValue: Double?

func doSomething(with binding: Binding<Double>) { ... }

doSomething(with: $optionalValue ?? 0)
```

##### Presentation

```swift
// 面板高度停留位置 (iOS 15+)
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
}

// 带选择绑定
@State private var selectedDetent: PresentationDetent = .medium

.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationDetents([.medium, .large], selection: $selectedDetent)
}

// 交互式关闭
.sheet(isPresented: $showSheet) {
    ContentView()
        .interactiveDismissDisabled()
}

// 自定义圆角 (iOS 15+)
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationCornerRadius(20)
}

// 背景交互
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationBackground(Color.clear)
        .presentationBackgroundInteraction(.enabled)
}

// 内容交互
.sheet(isPresented: $showSheet) {
    ContentView()
        .presentationContentInteraction(.scrolls)
}
```

##### Loading

```swift
// 基础加载
@State private var isLoading = false

Button("显示加载") {
    isLoading = true
}
.loading(isPresented: $isLoading) {
    ProgressView()
        .scaleEffect(1.5)
}

// 带选项
.loading(
    isPresented: $isLoading,
    options: LoadingOptions(
        hideAfter: 3.0,                    // 3秒后自动隐藏
        backdrop: .black.opacity(0.5),      // 黑色背景
        animation: .easeInOut,
        modifierType: .fade,                // 或 .scale
        dismissOnTap: true                  // 点击关闭
    )
) {
    VStack {
        ProgressView()
        Text("加载中...")
            .foregroundColor(.white)
    }
    .padding(30)
    .background(Color.gray.opacity(0.8))
    .cornerRadius(10)
}

// 使用 LoadingManager (编程方式)
let manager = LoadingManager()

// 添加到根视图
MyRootView()
    .addLoading(manager)

// 显示不同类型
manager.text = "请稍候..."
manager.showLoading()

manager.text = "加载中: 50%"
manager.progress = 0.5
manager.showProgress()

manager.text = "成功！"
manager.showSuccess()

manager.text = "失败！"
manager.showFail()

// 隐藏
manager.hide()

// 自定义样式
manager.textColor = .white
manager.textFont = .headline
manager.accentColor = .blue
manager.maskColor = .black.opacity(0.5)
```

##### Keychain

```swift
// 使用 KeychainService (推荐)
let service = KeychainService.shared

// 保存值
service.set("John", forKey: "name")
service.set(25, forKey: "age")
service.set(true, forKey: "isEnabled")
service.set(Data(), forKey: "data")

// 读取值
let name: String? = service.string(forKey: "name")
let age: Int? = service.integer(forKey: "age")
let isEnabled: Bool? = service.bool(forKey: "isEnabled")
let data: Data? = service.data(forKey: "data")

// 检查值是否存在
let hasName = service.hasValue(forKey: "name")

// 删除值
service.removeObject(forKey: "name")

// 删除所有键
service.removeAllKeys()

// 直接使用 KeychainWrapper
let wrapper = KeychainWrapper(serviceName: "com.example.app")

wrapper.set("secret", forKey: "password")
let password = wrapper.string(forKey: "password")

// 设置可访问性
wrapper.set("data", forKey: "key", with: .whenUnlocked)

// 清除整个钥匙串（谨慎使用！）
KeychainWrapper.wipeKeychain()
```

##### Language

```swift
// 使用 LanguageSettings (单例)
let settings = LanguageSettings.shared

// 获取当前语言
let currentLanguage = settings.selectedLanguage

// 设置语言
settings.selectedLanguage = .en
settings.selectedLanguage = .zhHans

// 获取设备语言
let deviceLang = settings.deviceLanguage

// 检查布局方向（用于阿拉伯语、希伯来语等从右到左的语言）
let isRTL = settings.isRightToLeft
let layoutDirection = settings.layout

// 使用 LanguageView 包装内容
LanguageView {
    VStack {
        Text("你好")
        Text("世界")
    }
}
// 自动应用正确的区域设置和布局方向

// 字符串本地化
let localizedString = "hello_world".localized
let formattedString = "greeting_message".localized.with("约翰", "你好")

// 获取可用语言列表
let languages = Localize.getList()
let available = Localize.availableLanguages()
```

##### List

```swift
// 空占位符 - 列表为空时显示视图
@State private var items: [String] = []

List {
    ForEach(items, id: \.self) { item in
        Text(item)
    }
}
.emptyPlaceholder(items) {
    VStack {
        Image(systemName: "tray")
            .font(.largeTitle)
        Text("暂无数据")
            .foregroundColor(.secondary)
    }
}

// 加载更多 - 进入视图时触发（放在LazyVStack中）
LazyVStack {
    ForEach(items, id: \.self) { item in
        Text(item)
    }
    LoadMoreView {
        // 滚动到底部时加载更多
        loadMoreItems()
    }
}
```

##### Progress

```swift
// 线性进度条
@State private var progress: Double = 0.5

LinearProgressBar(progress: progress)
    .linearProgressBarStyle(.standard)

// 自定义样式
LinearProgressBar(progress: 0.8)
    .linearProgressBarStyle(.padding)

LinearProgressBar(progress: 0.6)
    .linearProgressBarStyle(.tallPadding)

// 自定义样式
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

// 圆形进度条
CircularProgressBar(progress: 0.65)
    .circularProgressBarStyle(.standard)

// 不显示文字
CircularProgressBar(progress: 0.8)
    .circularProgressBarStyle(.noText)

// 自定义圆形样式
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

// 自定义高度的 ProgressView
ProgressView(value: 0.5)
    .progressViewStyle(.heightBar(height: 10, foregroundColor: .blue))

ProgressView(value: 0.7)
    .progressViewStyle(.heightBar(
        height: 6,
        foregroundColor: .green,
        backgroundColor: .gray.opacity(0.3)
    ))

// 圆形进度样式
ProgressView(value: 0.6)
    .progressViewStyle(CircularProgressStyle(strokeColor: .blue, strokeWidth: 8))

// 闪烁视图（加载动画）
FlickeringView(count: 5)
    .frame(width: 100, height: 100)
    .foregroundColor(.blue)
```

##### Refresh

```swift
// 带默认头部
List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)

// 自定义头部
List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshHeader {
    CustomRefreshHeaderView()
}

// 自定义底部
List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshFooter {
    CustomRefreshFooterView()
}
```

##### Refresh

```swift
// 启用 List 下拉刷新
@State private var isRefreshing = false

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)

// 使用默认头部
List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshHeader {
    DefaultRefreshHeader(refreshing: $isRefreshing, refreshText: "下拉刷新") {
        // 刷新操作 - 加载新数据
        await loadData()
        isRefreshing = false
    }
}

// 自定义头部（带进度）
@State private var refreshing = false

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshHeader {
    Refresh.Header(refreshing: $refreshing) { progress in
        // progress: 0.0 到 1.0+ (超过1.0触发刷新)
        VStack {
            if refreshing {
                ProgressView()
            } else {
                Text("下拉进度: \(Int(progress * 100))%")
            }
        }
    } action: {
        await loadData()
    }
}

// 使用默认底部（加载更多）
@State private var isLoadingMore = false

List(items, id: \.id) { item in
    Text(item.name)
}
.enableRefresh(true)
.refreshFooter {
    DefaultFooter(refreshing: $isLoadingMore, noMoreText: "没有更多数据") {
        await loadMore()
    }
}

// 自定义底部（无更多数据状态）
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
                Text("加载中...")
            }
        }
    }
    .noMore(!hasMoreData)  // 无更多数据时隐藏底部
    .preload(offset: 50)  // 距离底部50pt时触发加载
}

// Refresh 命名空间类型别名
typealias RefreshHeader = Refresh.Header
typealias RefreshFooter = Refresh.Footer
typealias DefaultRefreshHeader = Refresh.DefaultHeader
typealias DefaultRefreshFooter = Refresh.DefaultFooter
```

##### ScrollView

```swift
// 隐藏滚动指示器
ScrollView {
    VStack(alignment: .leading) {
        ForEach(0..<100) {
            Text("行 \($0)")
        }
    }
}
.ss.scrollIndicators(.hidden)

// 显示指定轴的指示器
ScrollView {
    LazyVStack {
        ForEach(0..<50, id: \.self) { i in
            Text("项 \(i)")
        }
    }
}
.ss.scrollIndicators(.visible, axes: .vertical)

// 禁用滚动
@State private var isScrollDisabled = false

ScrollView {
    VStack {
        Toggle("禁用", isOn: $isScrollDisabled)
        MyContent()
    }
}
.ss.scrollDisabled(isScrollDisabled)

// 键盘关闭行为
@State var text = ""

ScrollView {
    TextField("提示", text: $text)
    ForEach(0 ..< 50) { index in
        Text("\(index)")
            .padding()
    }
}
.ss.scrollDismissesKeyboard(.immediately)

// 不同的键盘关闭模式
.ss.scrollDismissesKeyboard(.automatic)  // 默认行为
.ss.scrollDismissesKeyboard(.interactively)  // 交互式关闭
.ss.scrollDismissesKeyboard(.never)  // 绝不关闭

// ScrollViewTracking - 跟踪滚动位置
@State private var currentScroll: CGFloat = 0

ScrollTrackingView(currentScroll: $currentScroll) {
    ForEach(0..<20, id: \.self) { index in
        Text("项 \(index)")
            .padding()
    }
}
// 使用 onScroll 监听滚动变化
.onScroll { offset in
    print("滚动偏移: \(offset)")
}
```

##### UnderLineText

```swift
// 基础用法
@State private var text = ""
@State private var date = Date()

UnderLineText()
    .underLineText(text)
    .underLineTitle("名称")
    .underLineColor(.gray)

// 带左侧/右侧视图
UnderLineText()
    .underLineText("一些文本")
    .underLineTitle("标签")
    .underLineLeadingView {
        Image(systemName: "person")
    }
    .underLineTrailingView {
        DatePicker("", selection: $date, displayedComponents: .date)
    }

// 自定义样式
UnderLineText()
    .underLineText("自定义")
    .underLineTitle("标题")
    .underLineTitleColor(.gray)
    .underLineTitleFont(.headline)
    .underLineTextColor(.black)
    .underLineTextFont(.body)
    .underLineColor(.blue)
    .underLineHeight(1)
    .underLineTextHeight(40)
    .underLineTextTruncationMode(.tail)
```

##### TextEditors

```swift
// 基础用法
@State private var text = ""

TextEditors("请输入文本", text: $text)
    .frame(height: 150)
    .border(Color.gray)

// 自定义内边距
TextEditors("占位符文本", text: $text)
    .padding(10)
    .background(Color.gray.opacity(0.1))
    .cornerRadius(8)

// 带文本限制
@State private var limitedText = ""

TextEditors("最多100个字符", text: $limitedText, textLimit: 100)
    .frame(height: 100)
```

##### TextEditorStyle

```swift
// 自动/普通样式
TextEditor(text: $text)
    .textEditorStyle(.automatic)

// 圆角边框
TextEditor(text: $text)
    .textEditorStyle(.roundedBorder)

// 自定义颜色边框
TextEditor(text: $text)
    .textEditorStyle(.roundedColorBorder(.blue, 2))

// 不同宽度的自定义颜色边框
TextEditor(text: $text)
    .textEditorStyle(.roundedColorBorder(.red, 5))
```

##### UIHostingConfiguration

```swift
// 用于UITableViewCell
cell.contentConfiguration = UIHostingConfiguration {
    HStack {
        Image(systemName: "star")
            .foregroundStyle(.purple)
        Text("收藏")
        Spacer()
    }
}

// 带背景
cell.contentConfiguration = UIHostingConfiguration {
    HStack {
        Image(systemName: "star")
            .foregroundStyle(.purple)
        Text("收藏")
        Spacer()
    }
}
.background {
    Color.blue
}

// 带边距
cell.contentConfiguration = UIHostingConfiguration {
    Text("我的内容")
}
.margins(.horizontal, 20)
.margins(.vertical, 10)

// 用于UICollectionViewCell
collectionCell.contentConfiguration = UIHostingConfiguration {
    VStack {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fill)
        Text("图片标题")
    }
}
.background(Color.gray.opacity(0.1))
.margins(.all, 8)
```

##### Triangle

```swift
// 基础向上三角形
Triangle()
    .fill(Color.blue)

// 倒置（向下）三角形
Triangle(inverted: true)
    .fill(Color.red)

// 带描边
Triangle()
    .stroke(Color.green, lineWidth: 2)

// 自定义尺寸
Triangle()
    .frame(width: 100, height: 100)
    .fill(Color.orange)
```

##### RoundedCorner

```swift
// 所有角落圆角
RoundedCorner(radius: 20, corners: .allCorners)
    .fill(Color.gray)

// 特定角落圆角 (iOS)
RoundedCorner(radius: 10, corners: [.topLeft, .topRight])
    .fill(Color.blue)

RoundedCorner(radius: 15, corners: [.bottomLeft, .bottomRight])
    .fill(Color.green)

// 单个角落
RoundedCorner(radius: 25, corners: .topLeft)
    .fill(Color.red)

// 应用到视图
Rectangle()
    .clipShape(RoundedCorner(radius: 20, corners: .allCorners))
```

##### CustomSegmentPicker

```swift
// 定义段落项
struct SegmentItem: Identifiable {
    let id = UUID()
    let title: String
}

@State private var selectedSegment: SegmentItem

// 基础用法
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

// 自定义颜色
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

// 使用RoundedRectangle背景
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

##### Others

```swift
// FlipView - 3D翻转卡片
@State private var isFlipped = false

FlipView(
    front: Color.green,
    back: Color.red,
    isFlipped: $isFlipped,
    flipDuration: 0.5,
    tapDirection: .right,
    swipeDirections: [.left, .right, .up, .down]
)

// MarqueeText - 滚动文本
MarqueeText("这是一段超出宽度的长文本，会自动滚动显示")

MarqueeText("自定义速度", spacing: 10, speed: 2.0)

// RadioButton - 单选按钮
RadioButton(isSelected: false, label: "选项1") { isSelected in
    print("选中: \(isSelected)")
}

// OtpView - OTP验证码输入
OtpView(activeColor: .blue, inActiveColor: .gray, length: 4) { code in
    print("输入验证码: \(code)")
}

// ExpandText - 展开收起文本
ExpandText(lineLimit: 2, animation: .easeInOut(duration: 0.2)) {
    Text("这是一段很长的文本，初始只显示2行，点击展开查看完整内容。")
} moreView: { action in
    Button(" ... 更多", action: action)
}

// CountDownTimerText - 倒计时
CountDownTimerText(timeCount: 60, timeUnit: "s", titleWhenIdle: "获取验证码", titleWhenFinished: "重新发送", mode: .manual) {
    return true  // 返回true开始倒计时
}

// AutoHeightTextEditor - 自动高度文本编辑器
@State private var text = ""
@State private var placeholder = "输入文本..."
@FocusState private var isFocused: Bool

AutoHeightTextEditor(
    inputText: $text,
    placeholder: $placeholder,
    textFocused: $isFocused
)

// RightArrow - 添加右侧箭头
Text("设置")
    .addRightArrow()

// RichText - 富文本
Text(separator: " ") {
    Text("你好")
        .font(.headline)
        .foregroundColor(.red)
    Text("世界")
        .fontWeight(.light)
}

// AnyButtonStyle - 自定义按钮样式
Button("点击我") {}
    .buttonStyle { config in
        config.label
            .padding()
            .background(config.isPressed ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
    }

// AppColorScheme - 应用主题管理
@StateObject var colorScheme = AppColorScheme()
colorScheme.darkModeSetting = .dark  // 或 .light, .system

// AnyViewModifier - 类型擦除的视图修饰器
let modifier = AnyViewModifier { content in
    content
        .padding()
        .background(Color.blue)
}
```

##### ScrollStack

```swift
// 垂直滚动堆栈 (带滚动的 VStack)
VScrollStack(spacing: 10, showsIndicators: true) {
    ForEach(0..<20, id: \.self) { index in
        Text("项 \(index)")
            .padding()
    }
}

// 水平滚动堆栈 (带滚动的 HStack)
HScrollStack(spacing: 15, showsIndicators: false) {
    ForEach(0..<10, id: \.self) { index in
        Image(systemName: "star.fill")
            .font(.largeTitle)
    }
}

// 垂直滚动网格 (3列)
VScrollGrid(rowsCount: 3, spacing: 10) {
    ForEach(0..<12, id: \.self) { index in
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.blue.opacity(0.6))
            .frame(height: 60)
    }
}

// 水平滚动网格 (2行)
HScrollGrid(rowsCount: 2, spacing: 10) {
    ForEach(0..<8, id: \.self) { index in
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.green.opacity(0.6))
            .frame(width: 80)
    }
}

// 固定宽度列
VScrollGrid.fixedColumns(widths: [80, 120, 80], spacing: 8) {
    ForEach(0..<9, id: \.self) { index in
        Text("列 \(index)")
    }
}

// 自适应列 (自动填充)
VScrollGrid.adaptiveColumns(minimum: 100, spacing: 10) {
    ForEach(0..<15, id: \.self) { index in
        Text("项 \(index)")
    }
}

// 单行水平网格 (水平列表常用)
HScrollGrid.singleRow(height: 80, spacing: 12) {
    ForEach(0..<10, id: \.self) { index in
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.mint.opacity(0.7))
            .frame(width: 100)
    }
}
```

##### Gestures

```swift
// 手势按钮 (不适用于 ScrollView)
@State private var isPressed = false

GestureButton(
    isPressed: $isPressed,
    pressAction: { print("按下") },
    releaseInsideAction: { print("在内部释放") },
    releaseOutsideAction: { print("在外部释放") },
    longPressDelay: 0.8,
    longPressAction: { print("长按") },
    doubleTapAction: { print("双击") },
    repeatAction: { print("重复") },
    label: { isPressed in
        Text("按钮")
            .foregroundColor(isPressed ? .gray : .white)
            .scaleEffect(isPressed ? 0.9 : 1.0)
    }
)

// ScrollView 手势按钮 (可在 ScrollView 内使用)
ScrollView {
    LazyVStack {
        ScrollViewGestureButton(
            isPressed: $isPressed,
            pressAction: { print("在滚动视图中按下") },
            releaseInsideAction: { print("释放") },
            label: { isPressed in
                Text("滚动视图按钮")
            }
        )
    }
}

// 滑动手势
.onSwipeGesture(
    maximumTime: 1,
    minimumDistance: 10,
    up: { print("上滑") },
    down: { print("下滑") },
    left: { print("左滑") },
    right: { print("右滑") }
)

// 手势按钮默认配置
GestureButtonDefaults.longPressDelay = 1.0
GestureButtonDefaults.doubleTapTimeout = 0.2
GestureButtonDefaults.repeatDelay = 1.0
```

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

`https://github.com/zjinhu/Brick_SwiftUI`，即可完成集成

### 手动安装

Brick_SwiftUI 也支持手动安装，只需将 Sources 文件夹中的 Brick_SwiftUI 文件夹拖入需要安装的项目即可


## 作者

zjinhu, 814030966@qq.com

## 更多加速 APP 开发的工具

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftMediator&theme=radical)](https://github.com/zjinhu/SwiftMediator)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftBrick&theme=radical)](https://github.com/zjinhu/SwiftBrick)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftLog&theme=radical)](https://github.com/zjinhu/SwiftLog)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftMesh&theme=radical)](https://github.com/zjinhu/SwiftMesh)

[![ReadMe Card](https://github-readme-stats-sigma-five.vercel.app/api/pin/?username=zjinhu&repo=SwiftNotification&theme=radical)](https://github.com/zjinhu/SwiftNotification)


## 许可证

Brick_SwiftUI 基于 MIT 许可证发布。详细信息请查看 LICENSE 文件。
