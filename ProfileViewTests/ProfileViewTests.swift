//
//  ProfileViewTests.swift
//  ProfileViewTests
//
//  Created by Юрий Клеймёнов on 05/02/2024.
//

import XCTest
@testable import ImFeed

class ProfileViewTests: XCTestCase {
    
    // MARK: - Test fetchUserProfile() call
    func testViewControllerCallsFetchUserProfile() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.fetchUserProfile() // Simulate viewDidLoad calling fetchUserProfile
        
        // Then
        XCTAssertTrue(presenter.fetchUserProfileCalled)
    }
    
    // MARK: - Test updateUIWithProfile()
    func testUpdateUIWithProfile() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let profileResult = ProfileResult(
            id: "1",
            username: "testuser",
            name: "Test User",
            firstName: "Test",
            lastName: "User",
            instagramUsername: nil,
            twitterUsername: nil,
            portfolioUrl: nil,
            bio: "This is a test bio",
            location: "Test City",
            totalLikes: 10,
            totalPhotos: 20,
            totalCollections: 5,
            profileImage: ProfileImage(small: "", medium: "", large: ""),
            links: UserLinks(self: "self_link", html: "html_link", photos: "photos_link", likes: "likes_link", portfolio: "portfolio_link", following: "following_link", followers: "followers_link")
        )
        
        let profile = Profile(from: profileResult)
        
        // When
        viewController.updateUIWithProfile(profile)
        
        // Then
        XCTAssertTrue(viewController.updateUIWithProfileCalled)
    }
    
    // MARK: - Test updateAvatar()
    func testUpdateAvatar() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let url = URL(string: "https://example.com/avatar.jpg")!
        
        // When
        viewController.updateAvatar(url: url)
        
        // Then
        XCTAssertTrue(viewController.updateAvatarCalled)
        XCTAssertEqual(viewController.avatarURL, url)
    }
    
    // MARK: - Test addGradientToLabels() and removeGradientsFromLabels()
    func testGradientHandling() {
        // Given
        let viewController = ProfileViewControllerSpy()
        
        // When
        viewController.addGradientToLabels()
        // Then
        XCTAssertTrue(viewController.addGradientToLabelsCalled)
        
        // When
        viewController.removeGradientsFromLabels()
        // Then
        XCTAssertTrue(viewController.removeGradientsFromLabelsCalled)
    }
    
    // MARK: - Test showError()
    func testShowError() {
        // Given
        let viewController = ProfileViewControllerSpy()
        let title = "Error"
        let message = "Something went wrong"
        
        // When
        viewController.showError(title: title, message: message)
        
        // Then
        XCTAssertTrue(viewController.showErrorCalled)
        XCTAssertEqual(viewController.alertTitle, title)
        XCTAssertEqual(viewController.alertMessage, message)
    }
}
