//
//  AuthViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 08/12/2023.
//

import UIKit

// MARK: - Protocols
protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewProtocol, didAuthenticateWithCode code: String)
}

protocol AuthViewProtocol: UIViewController {
    func displayData(data: AuthScreenModel)
    var delegate: AuthViewControllerDelegate? { get }
}

// MARK: - AuthViewController
final class AuthViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    var presenter: AuthPresenter?
    
    private var logoImageView = UIImageView()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = .cornerRadius
        button.accessibilityIdentifier = "Authenticate"
        return button
    }()
    
    private var screenModel: AuthScreenModel = .empty {
        didSet { setup() }
    }
    
    // MARK: - Initialisation
    init(delegate: AuthViewControllerDelegate, authConfiguration: AuthConfiguration) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        self.presenter = AuthPresenter(view: self, authConfiguration: authConfiguration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setup()
        configureView()
    }
    
    // MARK: - Private methods
    private func setup() {
        view.backgroundColor = screenModel.backgroundColor
        logoImageView.image = screenModel.logoImage
        configureSignInButton()
    }
    
    private func configureView() {
        configureSubviews()
        configureConstraints()
    }
    
    private func configureSignInButton() {
        signInButton.setTitle(screenModel.buttonTitle, for: .normal)
        signInButton.backgroundColor = screenModel.buttonColor
        signInButton.setTitleColor(screenModel.backgroundColor, for: .normal)
        signInButton.titleLabel?.font = screenModel.font
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signInButtonTapped() {
        presenter?.signIn()
    }
    
    private func configureConstraints() {
        setupSignInButtonConstraints()
        setupLogoConstraints()
    }
    
    private func configureSubviews() {
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
    }
    
    private func setupSignInButtonConstraints() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: .sighInButtonHeight),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.insets),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .insets),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -.bottomInsets)
        ])
    }
    
    private func setupLogoConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: .logoSize),
            logoImageView.heightAnchor.constraint(equalToConstant: .logoSize)
        ])
    }
}

// MARK: - WebViewControllerDelegate
extension AuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

// MARK: - AuthViewProtocol
extension AuthViewController: AuthViewProtocol {
    func displayData(data: AuthScreenModel) {
        self.screenModel = data
    }
}

// MARK: - Static variables
fileprivate extension CGFloat {
    static let sighInButtonHeight: CGFloat = 48
    static let insets: CGFloat = 16
    static let bottomInsets: CGFloat = 90
    static let logoSize: CGFloat = 60
    static let cornerRadius: CGFloat = 16
}
