//
//  ImagesListViewControllerSpy.swift
//  ImagesListTests
//
//  Created by Юрий Клеймёнов on 06/02/2024.
//

import XCTest
@testable import ImFeed

// MARK: - ImagesListViewControllerSpy
class ImagesListViewControllerSpy: ImagesListViewProtocol {
    var presenter: ImagesListPresenterProtocol?
    var updateTableViewAnimatedCalled = false

    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
