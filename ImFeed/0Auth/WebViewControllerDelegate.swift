//
//  WebViewControllerDelegate.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 09/12/2023.
//

import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
