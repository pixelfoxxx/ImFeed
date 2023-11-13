import UIKit

final class ImagesListCell: UITableViewCell {

    // MARK: - Cell Identifier
    static let reuseIdentifier = "ImagesListCell"

    // MARK: - IBOutlets
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Gradient
    private var gradientLayer: CAGradientLayer?

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradientToImageBottom()
    }

    // MARK: - Gradient Layer
    private func addGradientToImageBottom() {
        gradientLayer?.removeFromSuperlayer()

        gradientLayer = CAGradientLayer()
        configureGradientLayerFrame()
        configureGradientLayerColors()
        configureGradientLayerOpacity()

        if let gradientLayer = gradientLayer {
            cellImage.layer.addSublayer(gradientLayer)
        }
    }

    private func configureGradientLayerFrame() {
        let gradientFrame = CGRect(x: 0, y: cellImage.bounds.height * 0.7, width: cellImage.bounds.width, height: cellImage.bounds.height * 0.3)
        gradientLayer?.frame = gradientFrame
    }

    private func configureGradientLayerColors() {
        gradientLayer?.colors = [UIColor.clear.cgColor, UIColor.gray.cgColor]
        gradientLayer?.locations = [0.0, 1.0]
    }

    private func configureGradientLayerOpacity() {
        gradientLayer?.opacity = 0.20
    }
}
