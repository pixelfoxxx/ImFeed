//
//  WebViewPresenter.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 31/01/2024.
//

import UIKit
import WebKit

// MARK: - WebViewPresenterProtocol
protocol WebViewPresenterProtocol: AnyObject {
    func loadWebView()
    func fetchCode(from navigationAction: WKNavigationAction) -> String?
}

// MARK: - WebViewPresenter
final class WebViewPresenter: WebViewPresenterProtocol {
    // MARK: - Properties
    weak var view: WebViewProtocol?
    
    // MARK: - Initialisation
    init(view: WebViewProtocol? = nil) {
        self.view = view
    }
    
    // MARK: - Public methods
    func loadWebView() {
        guard let url = URL(string: WebConstants.unsplashAuthorizeURL) else { return }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: WebConstants.accessKey),
            URLQueryItem(name: "redirect_uri", value: WebConstants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: WebConstants.accessScope)
        ]
        if let url = urlComponents.url {
            let request = URLRequest(url: url)
            view?.loadRequest(request: request)
        }
    }
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url,
              let urlComponents = URLComponents(string: url.absoluteString),
              urlComponents.path == WebConstants.authorizedPath,
              let codeItem = urlComponents.queryItems?.first(where: { $0.name == "code" }) else {
            return nil
        }
        return codeItem.value
    }
}
