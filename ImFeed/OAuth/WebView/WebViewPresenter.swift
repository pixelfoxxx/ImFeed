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
    private var authHelper: AuthHelperProtocol
    
    // MARK: - Initialisation
    init(view: WebViewProtocol? = nil, authHelper: AuthHelperProtocol) {
        self.view = view
        self.authHelper = authHelper
    }
    
    // MARK: - Public methods
    func loadWebView() {
        guard let request = authHelper.authRequest() else {
            return
        }
        view?.loadRequest(request: request)
    }
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else {
            return nil
        }
        return authHelper.code(from: url)
    }
    
    func updateProgress(progress: Float) {
        let isProgressComplete = progress >= 1.0
        view?.updateProgress(progress: isProgressComplete ? 0: progress)
    }
}
