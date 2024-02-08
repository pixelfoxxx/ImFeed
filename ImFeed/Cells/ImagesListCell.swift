import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    // MARK: - Cell Identifier
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Properties
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UI Components
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "LikeButton"
        
        return button
    }()
    private var gradientLayer: CAGradientLayer?
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .cornerRadius
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.ypWhite
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        return label
    }()
    
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = gradientView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImageView.kf.cancelDownloadTask()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func likeButtonTapped() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Private Methods
    private func configureCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        containerView.addSubview(cellImageView)
        containerView.addSubview(gradientView)
        containerView.addSubview(likeButton)
        cellImageView.addSubview(dateLabel)
        
        setupContainerView()
        setupImage()
        setupGradientView()
        setupLabel()
        setupLikeButton()
    }
    
    private func setupGradientView() {
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
    
    private func setupImage() {
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .imageInsets),
            cellImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.leadingTrailingInsets),
            cellImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .leadingTrailingInsets),
            cellImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.imageInsets),
        ])
    }
    
    private func setupLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImageView.leadingAnchor, constant: .insets),
            dateLabel.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: -.insets),
            dateLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -.insets),
            dateLabel.widthAnchor.constraint(equalToConstant: .labelWidth)
        ])
    }
    
    private func setupLikeButton() {
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: .buttonWidthHeight),
            likeButton.heightAnchor.constraint(equalToConstant: .buttonWidthHeight)
        ])
        
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    private func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        containerView.backgroundColor = .clear
    }
    
    func configure(with photo: Photo, dateFormatter: DateFormatter) {
        cellImageView.kf.indicatorType = .activity
        cellImageView.kf.setImage(with: URL(string: photo.smallImageURL), placeholder: UIImage(named: "loading_stub"))
        dateLabel.text = dateFormatter.string(from: photo.createdAtDate)
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    private func addGradient() {
        if gradientLayer == nil {
            let gradientLayer = CAGradientLayer()
            let colorTop = UIColor.ypGradient.withAlphaComponent(0).cgColor
            let colorBottom = UIColor.ypWhite.withAlphaComponent(0.2).cgColor
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.7, 1.0]
            gradientView.layer.insertSublayer(gradientLayer, at: 0)
            self.gradientLayer = gradientLayer
        }
    }
}

fileprivate extension CGFloat {
    static let insets: CGFloat = 8
    static let labelWidth: CGFloat = 18
    static let buttonWidthHeight: CGFloat = 44
    static let cornerRadius: CGFloat = 16
    static let imageInsets: CGFloat = 4
    static let leadingTrailingInsets: CGFloat = 16
}
