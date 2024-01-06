import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Properties
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.numberOfLines = 0
        label.text = "Loading ..."
        
        return label
    }()
    
    let userLoginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypGray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.text = "Loading ..."
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 0
        label.text = "Loading ..."
        
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
        
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureConstraints()
        startLoadingAnimation()
        fetchUserProfile()
        addProfileImageObserver()
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Private methods
    private func updateAvatar() {
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "user_photo"))
    }
    
    private func startLoadingAnimation() {
        animateLabel(label: userNameLabel)
        animateLabel(label: userLoginLabel)
        animateLabel(label: descriptionLabel)
    }
    
    private func animateLabel(label: UILabel) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.autoreverse, .repeat], animations: {
            label.alpha = 0.5
        }, completion: nil)
    }
    
    private func stopLoadingAnimation() {
        userNameLabel.layer.removeAllAnimations()
        userLoginLabel.layer.removeAllAnimations()
        descriptionLabel.layer.removeAllAnimations()
        userNameLabel.alpha = 1
        userLoginLabel.alpha = 1
        descriptionLabel.alpha = 1
    }
    
    private func updateUIWithProfile(_ profile: Profile) {
        stopLoadingAnimation()
        userNameLabel.text = profile.name
        userLoginLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
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
    }
    
    // MARK: - Fetching User Profile
    private func fetchUserProfile() {
        guard let token = tokenStorage.token else { return }
        
        profileService.fetchProfile(with: token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.updateUIWithProfile(profile)
                    self?.fetchProfileImageURL(for: profile.username)
                case .failure: break
                    // TODO: Add error alert
                }
            }
        }
    }
    
    private func fetchProfileImageURL(for username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.updateAvatar()
                case .failure: break
                    // TODO: Add error alert
                }
            }
        }
    }
    
    // MARK: - Profile logout
    private func logout() {
        tokenStorage.clearToken()
        cleanCookiesAndData()
        navigateToInitialScreen()
    }
    
    @objc private func logoutButtonTapped() {
        logout()
    }
    
    private func cleanCookiesAndData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func navigateToInitialScreen() {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.switchToInitialViewController()
            }
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
                self.updateAvatar()
            }
        updateAvatar()
    }
}
