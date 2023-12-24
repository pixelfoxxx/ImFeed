//
//  ProfileResult.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

struct ProfileResult: Codable {
    var id: String
    var username: String
    var name: String
    var firstName: String
    var lastName: String?
    var instagramUsername: String?
    var twitterUsername: String?
    var portfolioUrl: String?
    var bio: String?
    var location: String?
    var totalLikes: Int
    var totalPhotos: Int
    var totalCollections: Int
    var profileImage: ProfileImage
    var links: UserLinks
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, bio, location
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioUrl = "portfolio_url"
        case totalLikes = "total_likes"
        case totalPhotos = "total_photos"
        case totalCollections = "total_collections"
        case profileImage = "profile_image"
        case links
    }
}

struct ProfileImage: Codable {
    var small: String
    var medium: String
    var large: String
}

struct UserLinks: Codable {
    var `self`: String
    var html: String
    var photos: String
    var likes: String
    var portfolio: String
    var following: String
    var followers: String
}
