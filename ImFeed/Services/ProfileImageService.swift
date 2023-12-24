//
//  ProfileImageService.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    private let tokenStorage = OAuth2TokenStorage.shared
    private (set) var avatarURL: String?
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let token = tokenStorage.token else {
            completion(.failure(URLError(.badServerResponse)))
            return
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
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
            let userResult = try JSONDecoder().decode(ProfileResult.self, from: data)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.avatarURL = userResult.profileImage.small
                completion(.success(userResult.profileImage.small))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.DidChangeNotification,
                    object: self,
                    userInfo: ["URL": self.avatarURL as Any]
                )
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
