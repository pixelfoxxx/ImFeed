import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    // MARK: - Properties
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService()
    
    // MARK: - Date Formatter
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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addImageListObserver()
        imagesListService.fetchPhotosNextPage()
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
    
    private func addImageListObserver() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.updateTableViewAnimated()
            }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
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
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            showSingleImageViewController(with: photos[indexPath.row])
        }
        
        private func showSingleImageViewController(with photo: Photo) {
            let singleImageVC = SingleImageViewController()
            singleImageVC.photo = photo
            let navigationController = UINavigationController(rootViewController: singleImageVC)
            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
        }
        
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let lastElement = imagesListService.photos.count - 1
            if indexPath.row == lastElement {
                imagesListService.fetchPhotosNextPage()
            }
        }
    }
    
    // MARK: - ImagesListCellDelegate
    extension ImagesListViewController: ImagesListCellDelegate {
        func imageListCellDidTapLike(_ cell: ImagesListCell) {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let photo = photos[indexPath.row]
            let isLike = !photo.isLiked
            
            UIBlockingProgressHUD.show()
            imagesListService.changeLike(photoId: photo.id, isLike: isLike) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success():
                        self?.photos[indexPath.row].isLiked = isLike
                        self?.tableView.reloadRows(at: [indexPath], with: .none)
                        UIBlockingProgressHUD.dismiss()
                    case .failure(let error):
                        UIBlockingProgressHUD.dismiss()
                        
                        let alert = UIAlertController(title: "Ошибка: \(error)", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Не надо", style: .cancel, handler: nil))
                        
                        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            strongSelf.imageListCellDidTapLike(cell)
                        }))
                        
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
