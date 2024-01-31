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
}

// MARK: - WebViewViewController
final class WebViewViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: WebViewControllerDelegate?
    var presenter: WebViewPresenter?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WebViewPresenter(view: self)
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
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // MARK: - WebView Observer
    private func webViewObserver() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()})
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
