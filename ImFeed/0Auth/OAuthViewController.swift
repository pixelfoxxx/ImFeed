//
//  OAuthViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import UIKit

final class OAuthViewController: UIViewController {
    // MARK: - Properties
    let showWebViewSegueIdentifier = "ShowWebView"
    
    let oauthService = OAuth2Service()
    let tokenStorage = OAuth2TokenStorage()
    
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
    
        oauthService.fetchAuthToken(with: code) { [weak self] result in
            switch result {
            case .success(let token):
                self?.tokenStorage.token = token
                print("Access Token Stored: \(token)")
            case .failure(let error):
                print("Authentication error: \(error.localizedDescription)")
                print("Token Stored failed")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
