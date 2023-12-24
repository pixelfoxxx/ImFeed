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
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthScreen"
    
    private let oauthService = OAuth2Service()
    private let profileService = ProfileService()
    private let tokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
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
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers.first as? OAuthViewController else {
                fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
    
    private func showAuthScreen() {
        performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
    }
    
    private func checkToken() {
        if tokenStorage.hasToken() {
            switchToTabBarController()
        } else {
            showAuthScreen()
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
                self.splashScreenLogo.isHidden = true
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                self.splashScreenLogo.isHidden = true
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfileImage(username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username: username) { [weak self] result in
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
