//
//  UrlsResult.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 06/01/2024.
//

import Foundation

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
