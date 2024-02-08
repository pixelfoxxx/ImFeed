//
//  ImagesListPresenter.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 05/02/2024.
//

import Foundation

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewProtocol? { get }
    func addObserver()
    func fetchPhotosNextPage()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewProtocol?
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    init(view: ImagesListViewProtocol?) {
        self.view = view
    }
    
    func addObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [ weak self ] _ in
                guard let self = self else { return }
                view?.updateTableViewAnimated()
            }
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
}
