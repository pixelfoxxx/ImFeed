//
//  Photo.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 28/12/2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String
    let createdAtDate: Date
    let welcomeDescription: String?
    let thumbImageURL: String
    let rawImageURL: String
    let fullImageURL: String
    let smallImageURL: String
    let regularImageURL: String
    var isLiked: Bool
}

extension Photo {
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        
        if let date = DateFormatter.iso8601.date(from: result.createdAt) {
            self.createdAtDate = date
        } else {
            self.createdAtDate = Date()
        }
        
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.rawImageURL = result.urls.raw
        self.fullImageURL = result.urls.full
        self.smallImageURL = result.urls.small
        self.regularImageURL = result.urls.regular
        self.isLiked = result.likedByUser
    }
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
}
