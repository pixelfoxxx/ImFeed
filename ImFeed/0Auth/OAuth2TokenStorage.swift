//
//  OAuth2TokenStorage.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let defaults = UserDefaults.standard
    private let tokenKey = "https://unsplash.com/oauth/token"
    
    var token: String? {
        get {
            return defaults.string(forKey: tokenKey)
        }
        set {
            defaults.set(newValue, forKey: tokenKey)
        }
    }
}
