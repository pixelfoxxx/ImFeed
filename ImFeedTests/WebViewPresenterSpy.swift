//
//  WebViewPresenterSpy.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 03/02/2024.
//

import Foundation
import WebKit

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var loadWebViewCalled: Bool = false
    var view: WebViewProtocol?
    
    func loadWebView() {
        loadWebViewCalled = true
        
        let mockRequest = URLRequest(url: URL(string: "https://example.com")!)
        view?.loadRequest(request: mockRequest)
    }
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        return nil
    }
}

