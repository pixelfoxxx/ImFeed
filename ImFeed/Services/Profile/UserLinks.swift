//
//  UserLinks.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 06/01/2024.
//

import Foundation

struct UserLinks: Codable {
    let `self`: String
    let html: String
    let photos: String
    let likes: String
    let portfolio: String
    let following: String
    let followers: String
}
