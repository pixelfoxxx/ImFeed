//
//  Constants.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import Foundation

struct WebConstants {
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    static let authorizedPath = "/oauth/authorize/native"
    static let accessKey = "rXrURYe234BybwPJw_VPgVK_kF73rsBA0JNzqeOaqB8"
    static let secretKey = "KwvFvmPzo2g_kmSk2OoS_qsl82nMbFqemqQURtXie64"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}
