//
//  Profile.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 24/12/2023.
//

import Foundation

struct Profile {
    var username: String
    var name: String
    var loginName: String {
        return "@\(username)"
    }
    var bio: String
    var profileImage: String
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName ?? "")"
        self.bio = profileResult.bio ?? ""
        self.profileImage = profileResult.profileImage.large
    }
}
