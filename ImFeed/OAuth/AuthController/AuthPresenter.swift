//
//  AuthPresenter.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 30/01/2024.
//

import UIKit

// MARK: - AuthPresenterProtocol
protocol AuthPresenterProtocol: AnyObject {
    func signIn()
    func setup()
}

// MARK: - AuthPresenter
final class AuthPresenter {
    
    // MARK: - Properties
    weak var view: AuthViewProtocol?
    
    // MARK: - Initialisation
    init(view: AuthViewProtocol) {
        self.view = view
    }
    
    // MARK: - Private Methods
    private func buildScreenModel() -> AuthScreenModel {
        .init(
            backgroundColor: UIColor.ypBlack,
            buttonTitle: "Войти",
            buttonColor: UIColor.ypWhite,
            logoImage: UIImage(named: "unsplash_logo") ?? UIImage(),
            font: .boldSystemFont(ofSize: 17)
        )
    }
    
    private func render() {
        view?.displayData(data: buildScreenModel())
    }
}

// MARK: - AuthPresenterProtocol
extension AuthPresenter: AuthPresenterProtocol {
    func signIn() {
        let webViewController = WebViewViewController()
        webViewController.delegate = view as? WebViewControllerDelegate
        let navigationController = UINavigationController(rootViewController: webViewController)
        navigationController.modalPresentationStyle = .fullScreen
        view?.present(navigationController, animated: true)
    }
    
    func setup() {
        render()
    }
}
