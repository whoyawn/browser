//
//  Tab.swift
//  acme-browser
//
//  Created by Huyanh Hoang on 11/13/21.
//

import WebKit

class Tab {
    let id: String
    let webView: WKWebView
    init(id: String, webView: WKWebView) {
        self.id = id
        self.webView = webView
    }
}
