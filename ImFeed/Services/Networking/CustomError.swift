//
//  CustomError.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 02/01/2024.
//

import Foundation

enum CustomError: Error {
    case missingToken
    case invalidResponse
    case urlError
    case unknownError
    case serverError(String)
    case decodingError
    case networkError(URLError)
}

extension CustomError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingToken:
            return "Authentication token is missing."
        case .invalidResponse:
            return "Invalid response from the server."
        case .urlError:
            return "URL formation error."
        case .unknownError:
            return "An unknown error occurred."
        case .serverError(let message):
            return "Server error: \(message)"
        case .decodingError:
            return "Error decoding response."
        case .networkError(let urlError):
            return "Network error: \(urlError.localizedDescription)"
        }
    }
}

