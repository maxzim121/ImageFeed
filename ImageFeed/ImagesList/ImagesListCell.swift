import Foundation
import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    weak var delegate: ImageListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var imageShown: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
            imageShown.kf.cancelDownloadTask()
        }
    
    
    public func setIsLiked(isLiked: Bool) {
        if isLiked {
            likeButton.imageView?.image = UIImage(named: "Like")
        } else {
            likeButton.imageView?.image = UIImage(named: "LikeDefault")
        }
    }
}
