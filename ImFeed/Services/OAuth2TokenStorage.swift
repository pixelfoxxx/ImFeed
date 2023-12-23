//
//  OAuth2TokenStorage.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let defaults = UserDefaults.standard
    private let tokenKey = "OAuth2Token"
    
    var token: String? {
        get { defaults.string(forKey: tokenKey) }
        set { defaults.set(newValue, forKey: tokenKey) }
    }
    
    func hasToken() -> Bool {
        return defaults.object(forKey: tokenKey) != nil
    }
}
