//
//  ImagesListPresenterSpy.swift
//  ImagesListTests
//
//  Created by Юрий Клеймёнов on 06/02/2024.
//

import XCTest
@testable import ImFeed

// MARK: - ImagesListPresenterSpy
class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    weak var view: ImagesListViewProtocol?
    var fetchPhotosNextPageCalled = false
    var addObserverCalled = false

    func addObserver() {
        addObserverCalled = true
    }

    func fetchPhotosNextPage() {
        fetchPhotosNextPageCalled = true
    }
}
