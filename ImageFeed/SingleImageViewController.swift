
import Foundation
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var image: UIImage?
    var urlString = ""
    
    @IBOutlet var sharingButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBAction func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSharingButton(_ sender: Any) {
        guard let imageShare = singleImageView.image else { return }
        let share = UIActivityViewController(activityItems: [imageShare], applicationActivities: nil)
        present(share, animated: true)
    }
    
    @IBOutlet var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage(urlString: urlString)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        scrollView.maximumZoomScale = 1.25
        scrollView.minimumZoomScale = 0.1
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, max(hScale, vScale)))
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


extension SingleImageViewController {
    func setImage(urlString: String) {
        singleImageView.image = image
        UIBlockingProgressHUD.show()
        guard let url = URL(string: urlString) else {
            showAllert(urlString: urlString)
            return
        }
        singleImageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let resultImage):
                self.image = resultImage.image
                self.rescaleAndCenterImageInScrollView(image: resultImage.image)
            case .failure(_):
                self.showAllert(urlString: urlString)
            }
        }
    }
    
    func showAllert(urlString: String) {
        let alertViewController = UIAlertController(title: nil, message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Не надо", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.dismiss(animated: true, completion: nil)
        }
        let actionRepeat = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.setImage(urlString: urlString)
        }
        alertViewController.addAction(actionCancel)
        alertViewController.addAction(actionRepeat)
        present(alertViewController, animated: true)
    }
}

