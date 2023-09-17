
import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    
    
    
    @IBOutlet var sharingButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSharingButton(_ sender: Any) {
        guard let image = image else {return}
        let sharingViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        self.present(sharingViewController, animated: true, completion: nil)
    }
    
    @IBOutlet var singleImageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {return}
            singleImageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 0.8
        rescaleAndCenterImageInScrollView(image: image)
        
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
            let visibleRectSize = scrollView.bounds.size
            let imageSize = image.size
            let hScale = visibleRectSize.width / imageSize.width
            let vScale = visibleRectSize.height / imageSize.height
            let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, min(hScale, vScale)))
            let targetWidth = imageSize.width * scale
            let targetHeight = imageSize.height * scale
            singleImageView.frame = CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight)
            scrollView.contentSize = singleImageView.frame.size
            view.layoutIfNeeded()
            scrollView.layoutIfNeeded()
            scrollView.zoomScale = scale
            let verticalPadding =  max(0, (scrollView.contentSize.height - scrollView.bounds.height) / 2)
            
            let horizontalPadding =  max(0, (scrollView.contentSize.width - scrollView.bounds.width) / 2)
            scrollView.contentOffset = CGPoint(x: horizontalPadding, y: verticalPadding)
        }

}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
            let imageViewSize = singleImageView.frame.size
            let scrollViewSize = scrollView.bounds.size
            
            let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
            let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
            
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        }
}
