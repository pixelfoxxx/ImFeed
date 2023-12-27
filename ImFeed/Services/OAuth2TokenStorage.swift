//
//  OAuth2TokenStorage.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation
import SwiftKeychainWrapper

// MARK: - OAuth2TokenStorage
final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let tokenKey = "OAuth2Token"
    
    var token: String? {
        get { return KeychainWrapper.standard.string(forKey: tokenKey) }
        set {
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
            }
        }
    }
    
    func hasToken() -> Bool {
        return KeychainWrapper.standard.hasValue(forKey: tokenKey)
    }
    
    private init() {}
}

// UserDefaults:
//  private let defaults = UserDefaults.standard

//        get { defaults.string(forKey: tokenKey) }
//        set { defaults.set(newValue, forKey: tokenKey) }

//        return defaults.object(forKey: tokenKey) != nil
