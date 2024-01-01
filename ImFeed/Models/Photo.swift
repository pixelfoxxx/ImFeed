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
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let rawImageURL: String
    let fullImageURL: String
    let smallImageURL: String
    let regularImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.rawImageURL = result.urls.raw
        self.fullImageURL = result.urls.full
        self.smallImageURL = result.urls.small
        self.regularImageURL = result.urls.regular
        self.isLiked = result.likedByUser
    }
}

