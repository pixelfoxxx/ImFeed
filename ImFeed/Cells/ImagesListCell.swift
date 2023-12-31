import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Cell Identifier
    static let reuseIdentifier = "ImagesListCell"
    // MARK: - IBOutlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    // MARK: - Gradient
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private var gradientLayer: CAGradientLayer?
    
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
        cellImage.addSubview(gradientView)
        cellImage.bringSubviewToFront(gradientView)
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: cellImage.topAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor)
        
        ])
        
        addGradient()
    }

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureGradientView()
    }
}
