import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var userLoginLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    
    
    @IBOutlet private var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton(_ sender: UIButton) {
        
    }
}
