//
//  Auth2Service.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 13/12/2023.
//

import Foundation

final class Auth2Service {
    
    func fetchAuthToken(with code: String, completion: @escaping (Result<String, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/oauth/token")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: WebConstants.accessKey),
            URLQueryItem(name: "client_secret", value: WebConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: WebConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        if let url = urlComponents?.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            print("Here is the request: \(request)")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      200...300 ~= response.statusCode,
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
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    }
}
