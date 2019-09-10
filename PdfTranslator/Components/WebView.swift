//
//  WebView.swift
//  PdfTranslate
//
//  Created by Viktor Kushnerov on 9/9/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

import SwiftUI
import WebKit
  
struct WebView : UIViewRepresentable {
    @Binding var text: URLQueryItem
      
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let lastUrl = uiView.url?.absoluteString.replacingOccurrences(of: "#view=home", with: "")
        let url = lastUrl ?? "https://translate.google.com?sl=auto&tl=ru"
        guard var urlComponent = URLComponents(string: url) else { return }
        guard var queryItems = urlComponent.queryItems else { return }
        

        queryItems.removeAll(where: { $0.name == text.name })
        queryItems.append(text)
        urlComponent.queryItems = queryItems
        
        uiView.load(URLRequest(url: urlComponent.url!))
    }
      
}

