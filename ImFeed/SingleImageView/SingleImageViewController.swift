import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: - Properties
    var imageUrl: URL?
    
    // MARK: - IB Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setSingleImage()
        setImageZoomScale()
    }
    
    // MARK: - IB Actions
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        if let url = imageUrl {
            let share = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil)
            present(share, animated: true)
        } else {
            print("No image to share")
        }
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Methods
    private func setImageZoomScale() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
    
    private func setSingleImage() {
        guard let imageUrl = imageUrl else {
            print("Invalid image URL")
            return
        }
        
        imageView.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "loading_stub"),
            options: [.transition(.fade(1))],
            progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                    self.rescaleAndCenterImageInScrollView(image: value.image)
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    
    private func rescaleAndCenterImageInScrollView(image: UIImage?) {
        guard let image = image else {
            print("No image to scale")
            return
        }
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
