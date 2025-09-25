//
//  WebView.swift
//  MetagAI
//
//  Created by iOS on 9/18/24.
//

import SwiftUI
//https://github.com/zmian/xcore/blob/main/Sources/Xcore/SwiftUI/Components/WebView/WebView.swift
#if os(iOS)
@preconcurrency import WebKit

public enum WebViewState: Error {
    case idle
    case didStart
    case didFail
    case didFinish
    case didTerminate
    case didCommit
}

public struct WebView: UIViewRepresentable {
    public typealias MessageHandler = @MainActor (_ body: String?) async throws -> Void
    public typealias PolicyDecision = @MainActor (_ webView: WKWebView,
                                                  _ action: WKNavigationAction) async -> WKNavigationActionPolicy
    
    private var webViewRef: Binding<WKWebView?> = .constant(nil)
    private let urlRequest: URLRequest
    private var messageHandlers: [String: MessageHandler] = [:]
    private var localStorageItems: [String: String] = [:]
    private var cookies: [HTTPCookie] = []
    private var showProgress = false
    private var progressColor: Color = .orange
    private var clearBackground = false
    private var showRefreshControl = true
    private var additionalConfiguration: (WKWebView) -> Void = { _ in }
    private var webViewState: Binding<WebViewState> = .constant(.idle)
    private var policyDecision: PolicyDecision = { _, action in
        guard let scheme = action.request.url?.schemeType else {
            return .allow
        }
        // Handle email, SMS, and telephone URLs natively.
        switch scheme {
        case .email, .sms, .tel:
            if let url = action.request.url,
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            return .cancel
        default:
            return .allow
        }
    }
    
    public init(url: URL) {
        self.init(urlRequest: .init(url: url))
    }
    
    public init(urlRequest: URLRequest) {
        self.urlRequest = urlRequest
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.userContentController = WKUserContentController()
        config.preferences = preferences
        config.allowsInlineMediaPlayback = true
        config.allowsAirPlayForMediaPlayback = true
        updateConfiguration(config, context: context)
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = false
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        if clearBackground{
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
        }
        
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        additionalConfiguration(webView)
        
        DispatchQueue.main.async {
            self.webViewRef.wrappedValue = webView
        }
        return webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        updateConfiguration(webView.configuration, context: context)
        if webView.url == nil {
            webView.load(urlRequest)
        }
    }
    
    public static func dismantleUIView(_ webView: WKWebView, coordinator: Coordinator) {
        webView.removeObserver(coordinator, forKeyPath: "estimatedProgress")
    }
    
    private func updateConfiguration(_ wkConfig: WKWebViewConfiguration, context: Context) {
        
        wkConfig.userContentController.removeAllScriptMessageHandlers()
        
        // 1. Set up message handlers
        messageHandlers.forEach { name, _ in
            wkConfig.userContentController.addScriptMessageHandler(
                context.coordinator,
                contentWorld: .page,
                name: name
            )
        }
        
        // 2. Set up cookies
        cookies.forEach {
            wkConfig.websiteDataStore.httpCookieStore.setCookie($0)
        }
        
        // 3. Set up user scripts
        localStorageItems.forEach { key, value in
            let script = WKUserScript(
                source: "window.localStorage.setItem(\"\(key)\", \"\(value)\");",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
            wkConfig.userContentController.addUserScript(script)
        }
    }
    
}

extension WebView {
    ///添加和JS交互功能，通过JS的postMessage调用原生代码----详见TestWebView
    ///Add and interact with JS functionality, call native code through JS's postMessage ---- see TestWebView for details.
    public func onMessageHandler(name: String, handler: MessageHandler?) -> Self {
        apply {
            $0.messageHandlers[name] = handler
        }
    }
    ///用于获取当前WebView的WKWebView对象，方便进行处理
    ///Used to obtain the WKWebView object of the current Web View for easy processing
    public func getWebViewObject(_ ref: Binding<WKWebView?>) -> Self {
        apply {
            $0.webViewRef = ref
        }
    }
    ///用户获取当前WebView的加载状态，并且在不同的状态可以做不同的处理，也可以自定义Loading
    ///The user obtains the loading status of the current WebView, and can do different processing in different states, or customizes Loading
    public func getWebViewState(_ state: Binding<WebViewState>) -> Self {
        apply {
            $0.webViewState = state
        }
    }
    ///设置网页Cookie
    ///Set web page cookies
    public func setCookies(_ cookies: [HTTPCookie]) -> Self {
        apply {
            $0.cookies = cookies
        }
    }
    ///加载本地存储的参数Debug环境在didFinish可以看到是否加载成功
    ///Load local storage parameters. Debug environment can see whether it is loaded successfully in did Finish.
    public func localStorageItem(_ item: String, forKey key: String) -> Self {
        apply {
            $0.localStorageItems[key] = item
        }
    }
    ///是否显示网页加载进度条
    ///Whether to display the WebView loading progress bar
    public func showProgress(_ value: Bool) -> Self {
        apply {
            $0.showProgress = value
        }
    }
    ///网页加载进度条颜色
    ///WebView loading progress bar color
    public func setProgressColor(_ color: Color) -> Self {
        apply {
            $0.progressColor = color
        }
    }
    ///清空WebView背景色，使WebView背景变透明，可以结合ZStack自定义背景色
    ///Clear the Web View background color to make the Web View background transparent, and you can customize the background color with ZStack
    public func clearBackgroundColor() -> Self {
        apply {
            $0.clearBackground = true
        }
    }
    ///添加额外配置，比如设置WebView的userAgent读取document.title等
    ///Add additional configurations, such as setting the userAgent of the WebView to read document.title, etc.
    public func additionalConfiguration(_ configuration: @escaping (WKWebView) -> Void) -> Self {
        apply {
            $0.additionalConfiguration = configuration
        }
    }
    
    public func policyDecision(_ decision: @escaping PolicyDecision) -> Self {
        apply {
            $0.policyDecision = decision
        }
    }
    
    public func showRefreshControl(_ value: Bool) -> Self {
        apply {
            $0.showRefreshControl = value
        }
    }
    
    private func apply(_ configure: (inout Self) throws -> Void) rethrows -> Self {
        var object = self
        try configure(&object)
        return object
    }
}

extension WebView {
    
    public final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandlerWithReply {
        
        private lazy var progressBar: UIProgressView = {
            let progressView = UIProgressView()
            progressView.trackTintColor = .gray.withAlphaComponent(0.1)
            progressView.tintColor = UIColor(parent.progressColor)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            return progressView
        }()
        
        // Added refreshControl property
        private var refreshControl = UIRefreshControl()
        
        private var didAddLoader = false
        
        private let parent: WebView
        private weak var webView: WKWebView?
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            // Ensure any main actor work is dispatched to main actor context
            guard let webView = object as? WKWebView else { return }
            
            // If any UI updates, ensure on main actor
            Task { @MainActor in
                self.webView = webView
                if parent.showRefreshControl {
                    refreshControl.addTarget(self, action: #selector(refreshWebView(_:)), for: .valueChanged)
                    webView.scrollView.refreshControl = refreshControl
                }
                if keyPath == "estimatedProgress", parent.showProgress {
                    let progress = webView.estimatedProgress
                    if !didAddLoader {
                        webView.addSubview(progressBar)
                        NSLayoutConstraint.activate([
                            progressBar.topAnchor.constraint(equalTo: webView.topAnchor),
                            progressBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
                            progressBar.widthAnchor.constraint(equalToConstant: Screen.realWidth),
                            progressBar.heightAnchor.constraint(equalToConstant: 4)
                        ])
                        didAddLoader = true
                    }
                    if progress >= 1.0 {
                        progressBar.setProgress(Float(progress), animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [weak self] in
                            self?.progressBar.alpha = 0.0
                            self?.progressBar.setProgress(0.0, animated: false)
                        }
                    } else {
                        progressBar.alpha = 1.0
                        progressBar.setProgress(Float(progress), animated: true)
                    }
                }
            }
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.webViewState.wrappedValue = .didStart
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
            parent.webViewState.wrappedValue = .didFail
        }
        
        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            parent.webViewState.wrappedValue = .didTerminate
        }
        
        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.webViewState.wrappedValue = .didCommit
        }
        
        // 页面加载完成之后调用
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
            parent.webViewState.wrappedValue = .didFinish
#if DEBUG
            parent.localStorageItems.forEach { key, expectedValue in
                webView.evaluateJavaScript("localStorage.getItem(\"\(key)\")") { (value, error) in
                    if let value = value as? String {
                        if expectedValue != value {
                            print("value in local storage: \(value)")
                        }
                    }
                    
                    if let error {
                        print("Failed to get the value for the \"\(key)\": \(error)")
                    }
                }
            }
#endif
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            await parent.policyDecision(webView, navigationAction)
        }
        
        @MainActor
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
            guard let messageHandler = parent.messageHandlers[message.name] else {
                return (nil, nil)
            }
            
            return (try? await messageHandler(message.body as? String), nil)
        }
        
        
        // Add refreshWebView method
        @objc private func refreshWebView(_ sender: UIRefreshControl) {
            sender.endRefreshing()
            webView?.reload()
        }
    }
}

extension WebView.Coordinator {
    public static func cleanAllWebsiteDataStoreIfNeeded() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let modifiedSince = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            debugPrint("Cleaning completed")
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}

#Preview {
    WebViewPreviewWrapper()
}

struct WebViewPreviewWrapper: View {
    @State var webView: WKWebView? = nil
    @State var webViewState:WebViewState = .idle
    
    var body: some View {
        WebView(url: URL(string: "https://www.baidu.com")!)
            .showProgress(true)
            .getWebViewObject($webView)
            .getWebViewState($webViewState)
            .setProgressColor(.green)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("back") {
                        if let webView = webView, webView.canGoBack {
                            webView.goBack()
                        }
                    }
                }
            }
            .onChange(of: webViewState) { newValue in
                print(newValue)
            }
            .onDisappear {
                WebView.Coordinator.cleanAllWebsiteDataStoreIfNeeded()
            }
    }
}
#endif

