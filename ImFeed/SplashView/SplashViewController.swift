//
//  SplashViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 22/12/2023.
//

import UIKit
import ProgressHUD

class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthScreen"
    private let oauthService = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    
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
        
        if tokenStorage.hasToken() {
            switchToTabBarController()
        } else {
            showAuthScreen()
        }
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
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: OAuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            self?.fetchAuthToken(code)
        }
    }
    
    private func fetchAuthToken(_ code: String) {
        oauthService.fetchAuthToken(with: code) { [weak self] result in
            switch result {
            case .success:
                self?.splashScreenLogo.isHidden = true
                self?.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure:
                print("Authorization error") // TODO: - Handle Authorization error
                self?.splashScreenLogo.isHidden = true
                UIBlockingProgressHUD.dismiss()
               
                
            }
        }
    }
}

