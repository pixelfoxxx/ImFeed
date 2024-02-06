//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Юрий Клеймёнов on 06/02/2024.
//

import XCTest
@testable import ImFeed

// MARK: - ImagesListTests
final class ImagesListTests: XCTestCase {
    // MARK: - Test fetchPhotosNextPage() call
    func testViewControllerCallsFetchPhotosNextPage() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.fetchPhotosNextPage()
        
        // Then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled)
    }
    
    // MARK: - Test addObserver() call
    func testViewControllerCallsAddObserver() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.addObserver()
        
        // Then
        XCTAssertTrue(presenter.addObserverCalled)
    }
    
    // MARK: - Test updateTableViewAnimated()
    func testUpdateTableViewAnimated() {
        // Given
        let viewController = ImagesListViewControllerSpy()
        
        // When
        viewController.updateTableViewAnimated()
        
        // Then
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
    }
}

