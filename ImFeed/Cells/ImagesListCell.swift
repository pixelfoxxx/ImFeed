import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    // MARK: - Cell Identifier
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Gradient
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureGradientView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    // MARK: - Private Methods
    func configure(with photo: Photo, dateFormatter: DateFormatter) {
        cellImageView.kf.indicatorType = .activity
        cellImageView.kf.setImage(with: URL(string: photo.smallImageURL), placeholder: UIImage(named: "loading_stub"))
        
        dateLabel.text = dateFormatter.string(from: Date())
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        let colorTop = UIColor.ypGradient.withAlphaComponent(0).cgColor
        let colorBottom = UIColor.ypWhite.withAlphaComponent(0.2).cgColor
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.7, 1.0]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
    private func configureGradientView() {
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        cellImageView.addSubview(gradientView)
        cellImageView.bringSubviewToFront(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor)
            
        ])
        
        addGradient()
    }
}
