//
//  Constants.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import Foundation

struct Constants {
    static let UnsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let AccessKey = "rXrURYe234BybwPJw_VPgVK_kF73rsBA0JNzqeOaqB8"
    static let SecretKey = "KwvFvmPzo2g_kmSk2OoS_qsl82nMbFqemqQURtXie64"
    static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let AccessScope = "public+read_user+write_likes"
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
}
