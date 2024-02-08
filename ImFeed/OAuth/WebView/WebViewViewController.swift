//
//  WebViewViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import UIKit
import WebKit

// MARK: - Protocols
protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

protocol WebViewProtocol: AnyObject {
    func loadRequest(request: URLRequest)
    func updateProgress(progress: Float)
}

// MARK: - WebViewViewController
final class WebViewViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: WebViewControllerDelegate?
    var presenter: WebViewPresenter?
    
    private var progressView = UIProgressView()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.accessibilityIdentifier = "UnsplashWebView"
        return webView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let authHelper = AuthHelper(configuration: .standard)
        presenter = WebViewPresenter(view: self, authHelper: authHelper)
        setupView()
        presenter?.loadWebView()
        webViewObserver()
        webView.navigationDelegate = self
    }
    
    // MARK: - UI Methods
    private func setupView() {
        view.addSubview(webView)
        view.addSubview(progressView)
        setupWebViewConstraints()
        setupProgressView()
        configureNavBar()
    }
    
    private func setupProgressView() {
        progressView.progressTintColor = UIColor.ypBlack
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func setupWebViewConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureNavBar() {
        if let backButtonImage = UIImage(named: "backward_nav_button")?.withRenderingMode(.alwaysOriginal) {
            let backButton = UIBarButtonItem(image: backButtonImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(backwardButtonTapped))
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc private func backwardButtonTapped() {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    internal func updateProgress(progress: Float) {
        DispatchQueue.main.async {
            self.progressView.progress = progress
            self.progressView.isHidden = progress == 0
        }
    }
    
    // MARK: - WebView Observer
    private func webViewObserver() {
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, change in
            guard let self = self, let newProgress = change.newValue else { return }
            self.presenter?.updateProgress(progress: Float(newProgress))
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = presenter?.fetchCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

// MARK: - WebViewProtocol
extension WebViewViewController: WebViewProtocol {
    func loadRequest(request: URLRequest) {
        webView.load(request)
    }
}
