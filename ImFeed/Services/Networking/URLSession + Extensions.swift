//
//  URLSession + Extensions.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let urlError = error as? URLError {
                    completion(.failure(CustomError.networkError(urlError)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(CustomError.invalidResponse))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    guard let data = data else {
                        completion(.failure(CustomError.invalidResponse))
                        return
                    }
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedObject))
                    } catch {
                        completion(.failure(CustomError.decodingError))
                    }
                default:
                    completion(.failure(CustomError.serverError("Status code: \(httpResponse.statusCode)")))
                }
            }
        }
        return task
    }
}
