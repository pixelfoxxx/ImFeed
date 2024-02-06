//
//  ImagesListViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 28/12/2023.
//

import UIKit
import Kingfisher

// MARK: - ImagesListViewProtocol
protocol ImagesListViewProtocol: AnyObject {
    func updateTableViewAnimated()
}

// MARK: - ImagesListViewController
final class ImagesListViewController: UIViewController, ImagesListViewProtocol {
    
    // MARK: - Properties
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .ypBlack
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var presenter: ImagesListPresenterProtocol!
    private var photos: [Photo] = []
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.fetchPhotosNextPage()
        presenter.addObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListPresenter(view: self)
        configureTableView()
    }
    
    // MARK: - Cell Configuration
    private func configureCell(_ cell: ImagesListCell, for indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        cell.configure(with: photo, dateFormatter: dateFormatter)
        cell.delegate = self
        cell.selectionStyle = .none
    }
    
    // MARK: - Private Methods
    private func configureTableView() {
        view.addSubview(tableView)
        view.backgroundColor = .ypBlack
        
        setupTableViewConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBlack
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        configureCell(cell, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageHeight = photo.size.height
        let imageWidth = photo.size.width
        
        let tableViewWidth = tableView.bounds.width
        let scaleFactor = tableViewWidth / imageWidth
        
        return imageHeight * scaleFactor
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = ImagesListService.shared.photos.count - 1
        if indexPath.row == lastElement {
            presenter.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showSingleImageViewController(with: ImagesListService.shared.photos[indexPath.row])
    }
    
    private func showSingleImageViewController(with photo: Photo) {
        let singleImageVC = SingleImageViewController()
        singleImageVC.photo = photo
        let navigationController = UINavigationController(rootViewController: singleImageVC)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let isLike = !photo.isLiked
        
        UIBlockingProgressHUD.show()
        
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: isLike) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success():
                    self?.photos[indexPath.row].isLiked = isLike
                    self?.configureCell(cell, for: indexPath)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    AlertPresenter.showConfirmationAlert(
                        on: self!,
                        title: "Ошибка: \(error)",
                        message: "Что-то пошло не так. Попробовать ещё раз?",
                        yesActionTitle: "Повторить",
                        noActionTitle: "Не надо",
                        yesAction: { [weak self] in
                            self?.imageListCellDidTapLike(cell)
                        })
                }
            }
        }
    }
}

// MARK: - updateTableViewAnimated
extension ImagesListViewController {
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
