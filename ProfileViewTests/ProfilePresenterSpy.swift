//
//  ProfilePresenterSpy.swift
//  ProfileViewTests
//
//  Created by Юрий Клеймёнов on 05/02/2024.
//

import Foundation
@testable import ImFeed

class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?

    // Variables to capture calls
    var fetchUserProfileCalled = false
    var updateAvatarCalled = false

    func fetchUserProfile() {
        fetchUserProfileCalled = true
    }

    func updateAvatar() {
        updateAvatarCalled = true
    }
}
