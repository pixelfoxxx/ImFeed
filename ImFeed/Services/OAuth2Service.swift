//
//  OAuth2Service.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation

// MARK: - OAuth2Service
final class OAuth2Service {
 
    // MARK: - Public Methods
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let url = buildRequestURL(with: code) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("Auth request: \(request)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    // MARK: - Private Methods
    private func buildRequestURL(with code: String) -> URL? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: WebConstants.accessKey),
            URLQueryItem(name: "client_secret", value: WebConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: WebConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        return urlComponents?.url
    }

    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              200...299 ~= response.statusCode,
              error == nil else {
            DispatchQueue.main.async {
                completion(.failure(error ?? URLError(.badServerResponse)))
            }
            return
        }

        do {
            let tokenResponse = try JSONDecoder().decode(AuthTokenResponseBody.self, from: data)
            DispatchQueue.main.async {
                completion(.success(tokenResponse.accessToken))
                OAuth2TokenStorage.shared.token = tokenResponse.accessToken
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
