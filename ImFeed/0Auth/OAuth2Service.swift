//
//  OAuth2Service.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation

final class OAuth2Service {
    
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://api.unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "client_id": Constants.AccessKey,
            "client_secret": Constants.SecretKey,
            "redirect_uri": Constants.RedirectURI,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
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
                let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(tokenResponse.accessToken))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
