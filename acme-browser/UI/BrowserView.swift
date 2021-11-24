//
//  BrowserView.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 11/14/21.
//

import Foundation
import UIKit
import WebKit

protocol BrowserDelegate: AnyObject {
    func urlDidLoad(url: URL)
}

class BrowserView: UIView {
    
    var webViewBackObserver: NSKeyValueObservation?
    var webViewForwardObserver: NSKeyValueObservation?
    var webViewURLObserver: NSKeyValueObservation?
    var webViewProgressObserver: NSKeyValueObservation?
    var delegate: BrowserDelegate?
        
    lazy var urlBar: URLBarView = {
        let urlBar = URLBarView()
        urlBar.translatesAutoresizingMaskIntoConstraints = false
        return urlBar
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.sizeToFit()
        return progressView
    }()
    
    var webView: WKWebView
    
    lazy var toolbar: BrowserToolbar = {
        let toolbar = BrowserToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    init(webView: WKWebView = WKWebView()) {
        self.webView = webView
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(urlBar)
        addSubview(progressView)
        addSubview(webView)
        addSubview(toolbar)
        
        backgroundColor = .systemBackground
        
        urlBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        urlBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        urlBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        urlBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        urlBar.updateTextField(text: webView.url?.absoluteString ?? "")
        
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        progressView.topAnchor.constraint(equalTo: urlBar.bottomAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        webView.topAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: urlBar.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: urlBar.trailingAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allowsBackForwardNavigationGestures = true
        if webView.url == nil {
            // In production environment replace this with a container view controller for suggested sites/homepage
            webView.load(URLRequest(url: URL(string: "https://neeva.co/")!))
        }
        //        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        toolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        toolbar.backButton.isEnabled = webView.canGoBack
        toolbar.forwardButton.isEnabled = webView.canGoForward
        
        webViewURLObserver = webView.observe(\.url, options: .new) { [weak self] webView, change in
            guard let url = change.newValue else { return }
            // we want a default value here but we also want to skip the delegate if we get nothing
            self?.urlBar.updateTextField(text: url?.absoluteString ?? "")
            if let url = url {
                self?.delegate?.urlDidLoad(url: url)
            }
        }
        
        webViewBackObserver = webView.observe(\.canGoBack, options: .new) { [weak self] webView, change in
            guard let canGoBack = change.newValue else { return }
            self?.toolbar.backButton.isEnabled = canGoBack
        }
        
        webViewForwardObserver = webView.observe(\.canGoForward, options: .new) { [weak self] webView, change in
            guard let canGoForward = change.newValue else { return }
            self?.toolbar.forwardButton.isEnabled = canGoForward
        }
        
        webViewForwardObserver = webView.observe(\.estimatedProgress, options: .new) { [weak self] webView, change in
            guard let estimatedProgress = change.newValue else { return }
            self?.progressView.isHidden = self?.progressView.progress != 1.0
            self?.progressView.progress = Float(estimatedProgress)
        }
    }
    
    deinit {
        webViewBackObserver?.invalidate()
        webViewURLObserver?.invalidate()
        webViewForwardObserver?.invalidate()
        webViewProgressObserver?.invalidate()
    }
}
