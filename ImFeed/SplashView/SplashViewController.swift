//
//  SplashViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 22/12/2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    
    // MARK: - Constants
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthScreen"

    // MARK: - Properties
    private let oauthService = OAuth2Service()
    private let profileService = ProfileService()
    private let tokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - IB Outlets
    @IBOutlet private weak var splashScreenLogo: UIImageView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkToken()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            prepareForAuthenticationScreenSegue(segue)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Error Handling
    private func showErrorAlert(message: String) {
        AlertPresenter.presentAlert(on: self, title: "Что-то пошло не так", message: message)
    }
    
    // MARK: - Authentication
    private func fetchOAuthToken(_ code: String) {
        oauthService.fetchAuthToken(with: code) { [weak self] result in
            guard let self = self else { return }
            self.handleOAuthTokenResult(result)
        }
    }
    
    private func handleOAuthTokenResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let token):
            fetchProfile(token: token)
        case .failure:
            UIBlockingProgressHUD.dismiss()
            showErrorAlert(message: "Не удалось войти в систему")
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(with: token) { [weak self] result in
            guard let self = self else { return }
            self.handleProfileResult(result)
        }
    }
    
    private func handleProfileResult(_ result: Result<Profile, Error>) {
        switch result {
        case .success(let profile):
            fetchProfileImage(username: profile.username)
            splashScreenLogo.isHidden = true
            UIBlockingProgressHUD.dismiss()
            switchToTabBarController()
        case .failure:
            splashScreenLogo.isHidden = true
            UIBlockingProgressHUD.dismiss()
            showErrorAlert(message: "Не удалось войти в систему")
        }
    }
    
    private func fetchProfileImage(username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleProfileImageResult(result)
            }
        }
    }
    
    private func handleProfileImageResult(_ result: Result<String, Error>) {
        switch result {
        case .success(let imageURL):
            print("Profile Image URL: \(imageURL)")
        case .failure:
            showErrorAlert(message: "Не удалось загрузить изображение профиля")
        }
    }
    
    // MARK: - Helper Methods
    private func prepareForAuthenticationScreenSegue(_ segue: UIStoryboardSegue) {
        guard let navigationController = segue.destination as? UINavigationController,
              let viewController = navigationController.viewControllers.first as? OAuthViewController else {
            fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
        }
        viewController.delegate = self
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func showAuthScreen() {
        performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
    }
    
    private func checkToken() {
        if tokenStorage.hasToken() {
            switchToTabBarController()
        } else {
            showAuthScreen()
        }
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
