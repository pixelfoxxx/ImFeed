//
//  ProfileImageService.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

final class ProfileImageService {
    // MARK: - Constants
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private static let baseURLString = "https://api.unsplash.com/users/"
    
    // MARK: - Properties
    private let tokenStorage = OAuth2TokenStorage.shared
    private (set) var avatarURL: String?
    
    // MARK: - Public Methods
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = createRequest(forUsername: username) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let userResult):
                    self?.handleSuccess(userResult: userResult, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    private func createRequest(forUsername username: String) -> URLRequest? {
        guard let url = URL(string: Self.baseURLString + username),
              let token = tokenStorage.token else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccess(userResult: ProfileResult, completion: (Result<String, Error>) -> Void) {
        avatarURL = userResult.profileImage.small
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self, userInfo: ["URL": avatarURL as Any])
        completion(.success(userResult.profileImage.small))
    }
}
