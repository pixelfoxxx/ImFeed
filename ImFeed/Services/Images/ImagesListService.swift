//
//  ImagesListService.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 28/12/2023.
//

import Foundation

final class ImagesListService {
    // MARK: - Constants
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private static let baseURLString = "https://api.unsplash.com/photos/"
    private static let itemsPerPage = 10
    
    // MARK: - Properties
    private let tokenStorage = OAuth2TokenStorage.shared
    private (set) var photos: [Photo] = []
    private var isFetching = false
    private var currentPage = 0
    
    // MARK: - Public Methods
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenStorage.token else {
            completion(.failure(CustomError.missingToken))
            return
        }
        
        let url = URL(string: Self.baseURLString + "\(photoId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        struct EmptyResponse: Decodable {}
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<EmptyResponse, Error>) in
            switch result {
            case .success:
                if let index = self?.photos.firstIndex(where: { $0.id == photoId }) {
                    self?.photos[index].isLiked = isLike
                    NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchPhotosNextPage() {
        guard !isFetching else { return }
        
        isFetching = true
        currentPage += 1
        guard let request = createRequest(page: currentPage) else {
            isFetching = false
            return
        }
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                self?.isFetching = false
                switch result {
                case .success(let photoResults):
                    self?.handleSuccess(photoResults: photoResults)
                case .failure:
                    self?.currentPage -= 1
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Private Methods
    private func createRequest(page: Int) -> URLRequest? {
        guard let url = URL(string: Self.baseURLString + "?page=\(page)"),
              let token = tokenStorage.token else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func handleSuccess(photoResults: [PhotoResult]) {
        let newPhotos = photoResults.map { Photo(from: $0) }
        photos.append(contentsOf: newPhotos)
        NotificationCenter.default.post(name: Self.didChangeNotification, object: self)
    }
}
