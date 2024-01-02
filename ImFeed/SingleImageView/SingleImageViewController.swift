import UIKit
import Kingfisher

fileprivate extension CGFloat {
    static let shareButtonSize: CGFloat = 50
}

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    var imageUrl: URL?
    private let imageView: UIImageView = {
        let photoView = UIImageView()
        photoView.contentMode = .scaleAspectFit
        
        return photoView
    }()
    
    private let sharedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sharing_button"), for: .normal)
        return button
    }()
    
    private let scrollView = UIScrollView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - UI Methods
    private func setupView() {
        view.addSubview(scrollView)
        view.addSubview(imageView)
        view.addSubview(sharedButton)
        view.backgroundColor = .ypBlack
        sharedButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        setImageZoomScale()
        setupSharingButton()
        setupNavigationBar()
        setupScrollView()
        setSingleImage()
        setupImage()
    }
    
    @objc private func shareButtonTapped() {
        guard let image = imageView.image else { return }
        let items = [image]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    private func setupNavigationBar() {
        let backItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backAction))
        backItem.tintColor = .white
        self.navigationItem.leftBarButtonItem = backItem
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor)
        ])
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSharingButton() {
        sharedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sharedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sharedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            sharedButton.widthAnchor.constraint(equalToConstant: .shareButtonSize),
            sharedButton.heightAnchor.constraint(equalToConstant: .shareButtonSize)
        ])
    }
    
    private func setImageZoomScale() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
    }
    
    private func setSingleImage() {
        guard let imageUrl = imageUrl else {
            print("Invalid image URL")
            return
        }
        
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "loading_stub"),
            options: [.transition(.fade(1))],
            progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
