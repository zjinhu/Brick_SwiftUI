//
//  WebView.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI
import WebKit

public struct WebView: UIViewControllerRepresentable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
    
    public func makeUIViewController(context: Context) -> WebViewController {
        let webViewController = WebViewController()
        return webViewController
    }

    public func updateUIViewController(_ webviewController: WebViewController, context: Context){

        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        DispatchQueue.main.async {
            webviewController.webView.load(request)
        }
    }
}

public class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    lazy var config: WKWebViewConfiguration = {
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
        
        return config
    }()
    
    public dynamic lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.old, .new], context: nil)
        return webView
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.trackTintColor = .clear
        progressView.tintColor = .red
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        cleanAllWebsiteDataStore()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
 
        view.addSubview(webView)
        view.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
            progressBar.topAnchor.constraint(equalTo: webView.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4)
        ])
 
    }
 
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
            case "estimatedProgress":
                if webView.estimatedProgress >= 1.0 {

                    UIView.animate(withDuration: 0.3, animations: { [weak self] () in
                        self?.progressBar.alpha = 0.0
                    }, completion: { _ in
                        self.progressBar.setProgress(0.0, animated: false)
                    })
                } else {
                    progressBar.isHidden = false
                    progressBar.alpha = 1.0
                    progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
                }
 
            default:
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func cleanAllWebsiteDataStore() {
        let websiteDataTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let modifiedSince = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: modifiedSince) {
            debugPrint("清理完成")
        }
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
}
