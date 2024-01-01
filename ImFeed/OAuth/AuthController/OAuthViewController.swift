//
//  OAuthViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import UIKit

fileprivate extension CGFloat {
    static let sighInButtonHeight: CGFloat = 48
    static let insets: CGFloat = 16
    static let bottomInsets: CGFloat = 90
    static let logoSize: CGFloat = 60
    static let cornerRadius: CGFloat = 16
}

final class OAuthViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OAuthViewControllerDelegate?
    
    private let unsplashLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "unsplash_logo")
        
        return imageView
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypWhite
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.clipsToBounds = true
        button.layer.cornerRadius = .cornerRadius
        
        return button
    }()
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureConstraints()
    }
    
    // MARK: - Navigation methods
    @objc private func signInButtonTapped() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
    
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        present(navigationController, animated: true)
    }
    
    // MARK: - UI Methods
    private func configureConstraints() {
        configureSplashLogoImage()
        configureSignInButtonConstraints()
    }
    
    private func configureSubviews() {
        view.addSubview(signInButton)
        view.addSubview(unsplashLogoImage)
        view.backgroundColor = .ypBlack
        
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    private func configureSplashLogoImage() {
        unsplashLogoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unsplashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            unsplashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureSignInButtonConstraints() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: .sighInButtonHeight),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.bottomInsets)
        ])
    }
}

// MARK: - WebViewControllerDelegate
extension OAuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
