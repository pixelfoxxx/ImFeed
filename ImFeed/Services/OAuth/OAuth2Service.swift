//
//  OAuth2Service.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation

// MARK: - OAuth2Service
final class OAuth2Service {
    // MARK: - Constants
    private let tokenStorage = OAuth2TokenStorage.shared
    private let authConfig = AuthConfiguration.standard
    
    // MARK: - Public Methods
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = buildRequestURL(with: code) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let tokenResponse):
                self.tokenStorage.token = tokenResponse.accessToken
                completion(.success(tokenResponse.accessToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    private func buildRequestURL(with code: String) -> URL? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: authConfig.accessKey),
            URLQueryItem(name: "client_secret", value: authConfig.secretKey),
            URLQueryItem(name: "redirect_uri", value: authConfig.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        return urlComponents?.url
    }
}
