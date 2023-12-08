//
//  WebViewViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet private var webView: WKWebView!
    
    weak var delegate: WebViewControllerDelegate?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        var urlComponents = URLComponents(string: Constants.UnsplashAuthorizeURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    //MARK: - IB Actions
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString), urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
