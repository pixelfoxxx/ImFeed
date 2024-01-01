//
//  SplashViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 22/12/2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let oauthService = OAuth2Service()
    private let profileService = ProfileService()
    private let tokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private let splashLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "YP Logo")
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureConstraints()
        checkToken()
    }
    
    // MARK: - Navigation
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func showAuthScreen() {
        let authViewController = OAuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func checkToken() {
        DispatchQueue.main.async {
            if self.tokenStorage.hasToken() {
                self.switchToTabBarController()
            } else {
                self.showAuthScreen()
            }
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauthService.fetchAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                AlertPresenter.showAlert(on: self, title: "Что-то пошло не так 😢", message: "Не удалось войти в систему")
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(with: token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.fetchProfileImage(username: profile.username)
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                AlertPresenter.showAlert(on: self, title: "Что-то пошло не так 😢", message: "Не удалось войти в систему")
                break
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let imageURL):
                    print("Profile Image URL: \(imageURL)")
                case .failure(let error):
                    print("Error fetching profile image URL: \(error)")
                }
            }
        }
    }
    
    // MARK: - UI Methods
    private func configureConstraints() {
        configureSplashLogoImage()
    }
    
    private func configureSubviews() {
        view.addSubview(splashLogoImage)
        view.backgroundColor = .ypBlack
    }
    
    private func configureSplashLogoImage() {
        splashLogoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashLogoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: OAuthViewControllerDelegate {
    func authViewController(_ vc: OAuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}
