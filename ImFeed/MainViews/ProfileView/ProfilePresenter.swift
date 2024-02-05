//
//  ProfilePresenter.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 05/02/2024.
//

import Foundation
import WebKit

// MARK: - ProfilePresenterProtocol
protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
}
