//
//  AuthHelper.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 03/02/2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func authURL() -> URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}
