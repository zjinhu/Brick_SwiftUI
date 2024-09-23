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
public struct WebView: UIViewRepresentable {
    public typealias MessageHandler = @MainActor (_ body: String?) async throws -> Void
    
    private let urlRequest: URLRequest
    private var messageHandlers: [String: MessageHandler] = [:]
    private var localStorageItems: [String: String] = [:]
    private var cookies: [HTTPCookie] = []
    private var showLoader = false
    private var clearBackground = false
    private var additionalConfiguration: (WKWebView) -> Void = { _ in }
    
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
        let processPool = WKProcessPool()
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.userContentController = WKUserContentController()
        config.preferences = preferences
        config.processPool = processPool
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
        
        if clearBackground{
            webView.isOpaque = false
            webView.backgroundColor = .clear
            webView.scrollView.backgroundColor = .clear
        }

        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        additionalConfiguration(webView)
        return webView
    }
    
    public func updateUIView(_ webView: WKWebView, context: Context) {
        updateConfiguration(webView.configuration, context: context)
        webView.load(urlRequest)
    }
    
    private func updateConfiguration(_ wkConfig: WKWebViewConfiguration, context: Context) {
        // Before re-injecting any script message handler, we need to ensure to remove
        // any existing ones to prevent crashes.
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
    public func onMessageHandler(name: String, handler: MessageHandler?) -> Self {
        apply {
            $0.messageHandlers[name] = handler
        }
    }
    
    public func cookies(_ cookies: [HTTPCookie]) -> Self {
        apply {
            $0.cookies = cookies
        }
    }
    
    public func localStorageItem(_ item: String, forKey key: String) -> Self {
        apply {
            $0.localStorageItems[key] = item
        }
    }
    
    public func showLoader(_ value: Bool) -> Self {
        apply {
            $0.showLoader = value
        }
    }
    
    public func clearBackgroundColor() -> Self {
        apply {
            $0.clearBackground = true
        }
    }
    
    public func additionalConfiguration(_ configuration: @escaping (WKWebView) -> Void) -> Self {
        apply {
            $0.additionalConfiguration = configuration
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
        private var didAddLoader = false
        private let loader = UIActivityIndicatorView(style: .large)
        private let parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            showLoader(true, webView)
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation, withError error: Error) {
            showLoader(false, webView)
        }
        
        //当 web 视图的内容进程终止时
        public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
            webView.reload()
            showLoader(false, webView)
        }
        
        public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            showLoader(true, webView)
        }
        
        // 页面加载完成之后调用
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
#if DEBUG
            // Dump local storage keys and values when the current value is different than
            // the expected value.
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
            showLoader(false, webView)
        }
        
        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let _ = navigationAction.request.url {
                // 处理重定向或其他 URL 逻辑
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        }
        
        @MainActor
        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) async -> (Any?, String?) {
            guard let messageHandler = parent.messageHandlers[message.name] else {
                return (nil, nil)
            }
            
            return (try? await messageHandler(message.body as? String), nil)
        }
        
        private func showLoader(_ show: Bool, _ view: WKWebView) {
            guard parent.showLoader else {
                return
            }
            if !didAddLoader {
                loader.color = .white
                loader.backgroundColor = .black.withAlphaComponent(0.6)
                loader.layer.cornerRadius = 10
                view.addSubview(loader)
                loader.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    loader.leftAnchor.constraint(equalTo: view.leftAnchor, constant: (view.frame.width-60)/2),
                    loader.topAnchor.constraint(equalTo: view.topAnchor, constant: (view.frame.height-60)/2),
                    loader.widthAnchor.constraint(equalToConstant: 60),
                    loader.heightAnchor.constraint(equalToConstant: 60)
                ])
                didAddLoader = true
            }
            show ? loader.startAnimating() : loader.stopAnimating()
        }
    }
}

//#Preview {
//    WebView(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Test", ofType: "html")!))
//        .showLoader(true)
//        .onMessageHandler(name: "iosBridge"){ message in
//            print("xxxxxx-----\(message)")
//        }
//}
#endif
