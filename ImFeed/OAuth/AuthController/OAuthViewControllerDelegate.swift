//
//  OAuthViewControllerDelegate.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

protocol OAuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: OAuthViewController, didAuthenticateWithCode code: String)
}
