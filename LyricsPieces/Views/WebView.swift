//
//  LyricsView.swift
//  LyricsPieces
//
//  Created by Greener Chen on 2024/9/4.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let url: URL?
    let htmlString: String?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.uiDelegate = context.coordinator
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        if let html = htmlString {
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        return WebViewCoordinator()
    }
}

class WebViewCoordinator: NSObject, WKUIDelegate {
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

#Preview {
    WebView(url: URL(string: "https://genius.com/Eminem-lucky-you-lyrics")!, htmlString: nil)
}
