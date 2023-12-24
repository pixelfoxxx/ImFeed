//
//  OAuthViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import UIKit

final class OAuthViewController: UIViewController {
    // MARK: - Properties
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    private let oauthService = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage.shared
    
    weak var delegate: OAuthViewControllerDelegate?
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier,
           let webViewViewController = segue.destination as? WebViewViewController {
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - WebViewControllerDelegate
extension OAuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
