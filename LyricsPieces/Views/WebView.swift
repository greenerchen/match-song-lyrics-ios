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
    
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebView(url: URL(string: "https://genius.com/Eminem-lucky-you-lyrics")!)
}
