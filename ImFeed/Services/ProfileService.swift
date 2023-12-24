//
//  ProfileService.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

// MARK: - ProfileService
final class ProfileService {
    // MARK: - Properties
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    // MARK: - Public Methods
    func fetchProfile(with token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error) { result in
                switch result {
                case .success(let profileResult):
                    let profile = Profile(from: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
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
            let profile = try JSONDecoder().decode(ProfileResult.self, from: data)
            DispatchQueue.main.async {
                completion(.success(profile))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
