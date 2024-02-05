//
//  ProfileViewController.swift
//  ImFeed
//
//  Created by Юрий Клеймёнов on 05/02/2024.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func updateUIWithProfile(_ profile: Profile)
    func addGradientToLabels()
    func removeGradientsFromLabels()
    func showError(title: String, message: String)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    // MARK: - UI Components
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        return label
    }()
    
    let userLoginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        return label
    }()
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "user_photo")
        
        return imageView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ipad.and.arrow.forward"), for: .normal)
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "logoutButton"
        
        return button
    }()
    
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var animationLayers = Set<CALayer>()
    private var gradientLayer: CAGradientLayer?
    
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = ProfilePresenter(view: self)
        presenter?.fetchUserProfile()
        addProfileImageObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setGradientFrames()
    }
    
    // MARK: - Public Methods
    func addGradientToLabels() {
        [userNameLabel, userLoginLabel, descriptionLabel].forEach { label in
            let gradient = createGradientLayer()
            label.layer.insertSublayer(gradient, at: 0)
            animationLayers.insert(gradient)
        }
    }
    
    func removeGradientsFromLabels() {
        animationLayers.forEach { $0.removeFromSuperlayer() }
        animationLayers.removeAll()
    }
    
    func updateAvatar(url: URL) {
        avatarImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(_):
                self?.removeGradientLayer()
            case .failure(_):
                break
            }
        }
    }
    
    func updateUIWithProfile(_ profile: Profile) {
        userNameLabel.text = profile.name
        userLoginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Private methods
    private func setupView(){
        configureSubviews()
        configureConstraints()
        addGradientLayer()
        addGradientToLabels()
    }
    
    private func logout() {
        CacheCleaner.clean()
        CacheCleaner.cleanCache()
        OAuth2TokenStorage.shared.clearToken()
        NavigationManager.shared.navigateToInitialScreen()
    }
    
    @objc private func logoutButtonTapped() {
        AlertPresenter.showConfirmationAlert(
            on: self,
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти? 😢",
            yesActionTitle: "Да",
            noActionTitle: "Нет",
            yesAction: { [weak self] in
                self?.logout()
            }
        )
    }
    
    private func configureSubviews() {
        view.addSubview(userNameLabel)
        view.addSubview(userLoginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(avatarImageView)
        view.addSubview(logoutButton)
        view.backgroundColor = .ypBlack
    }
    
    private func configureConstraints() {
        configureUserNameLabel()
        configureUserLoginLabel()
        configureDescriptionLabel()
        configureAvatarImageView()
        configureLogoutButton()
    }
    
    private func configureUserNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            userNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func configureUserLoginLabel() {
        userLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userLoginLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            userLoginLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userLoginLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userLoginLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: userLoginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func configureAvatarImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 70 / 2
    }
    
    private func configureLogoutButton() {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.widthAnchor.constraint(equalToConstant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 22),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Gradient & Loading animation
    private func addGradientLayer() {
        let gradient = createGradientLayer()
        gradientLayer = gradient
        avatarImageView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func removeGradientLayer() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
    private func createGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        
        gradient.locations = [0, 0.1, 0.3]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = 9
        gradient.masksToBounds = true
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        
        return gradient
    }
    
    private func setGradientFrames() {
        gradientLayer?.frame = avatarImageView.bounds
        gradientLayer?.cornerRadius = avatarImageView.frame.height / 2
        
        for label in [userNameLabel, userLoginLabel, descriptionLabel] {
            let gradientLayer = animationLayers.first(where: { $0.superlayer == label.layer })
            gradientLayer?.frame = label.bounds
        }
    }
    
    // MARK: - Notification Center Observer
    private func addProfileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.presenter?.updateAvatar()
            }
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
