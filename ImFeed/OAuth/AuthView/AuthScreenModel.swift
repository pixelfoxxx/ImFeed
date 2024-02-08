//
//  AuthScreenModel.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 30/01/2024.
//

import UIKit

// MARK: - AuthScreenModel
struct AuthScreenModel {
    let backgroundColor: UIColor
    let buttonTitle: String
    let buttonColor: UIColor
    let logoImage: UIImage
    let font: UIFont
    
    static let empty: AuthScreenModel = .init(
        backgroundColor: .clear,
        buttonTitle: "",
        buttonColor: .clear,
        logoImage: UIImage(),
        font: UIFont()
    )
}
