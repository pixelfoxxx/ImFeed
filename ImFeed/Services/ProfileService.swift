//
//  ProfileService.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

// MARK: - ProfileService
final class ProfileService {
    // MARK: - Constants
    static let shared = ProfileService()
    private static let profileURLString = "https://api.unsplash.com/me"
    
    // MARK: - Properties
    private(set) var profile: Profile?
    
    // MARK: - Public Methods
    func fetchProfile(with token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let request = createRequest(withToken: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    self?.handleSuccess(profileResult: profileResult, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    private func createRequest(withToken token: String) -> URLRequest? {
        guard let url = URL(string: Self.profileURLString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccess(profileResult: ProfileResult, completion: (Result<Profile, Error>) -> Void) {
        let profile = Profile(from: profileResult)
        self.profile = profile
        completion(.success(profile))
    }
}
