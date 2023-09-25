import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    
    @IBOutlet weak private var tableView: UITableView!
    
    private let imageListService = ImageListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var dateFormater = FormatDate()
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(photos)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        
        imageListService.fetchPhotosNextPage()
        
        UIBlockingProgressHUD.show()
                
        imageListServiceObserver = NotificationCenter.default.addObserver(forName:ImageListService.DidChangeNotification,
                                                                          object: nil,
                                                                          queue: .main) { [weak self] _ in
            
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            self.updateTableViewAnimated()
            print("update0")
        }
        UIBlockingProgressHUD.dismiss()
        self.updateTableViewAnimated()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.urlString = photos[indexPath.row].largeImageURL
            print("вызвали функцию")
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        
        return cellHeightCalculator(imageSize: imageSize, tableView: tableView)
    }

}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        
        //TODO:
        //Внести в отдельные константы дату и лайк, написать функцию в ImageListCell
        //Также в SimgleImageView прописать функцию картинки
        let urlString = photos[indexPath.row].thumbImageURL
        guard let url = URL(string: urlString) else { return imageListCell}
        imageListCell.imageShown.kf.indicatorType = .activity
        imageListCell.imageShown.kf.setImage(with: url,placeholder: UIImage(named: "placeholder")) { [weak self] _ in
            guard let self = self else {return}
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        imageListCell.dateLabel.text = dateFormater.setupUIDateString(date: photos[indexPath.row].createdAt)
        imageListCell.setIsLiked(isLiked: photos[indexPath.row].isLiked)
        return imageListCell
    }
}

extension ImagesListViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imageListService.photos.count { imageListService.fetchPhotosNextPage() }
    }
    
}

private extension ImagesListViewController {
    func updateTableViewAnimated() {
        print("update1")
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        print("update2")
        print(oldCount)
        print(newCount)
        if oldCount != newCount {
            print("update5")
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                print(indexPaths)
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
        print("update3")
    }
    
    func cellHeightCalculator(imageSize: CGSize, tableView: UITableView) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.photos = self.imageListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                //Показать ошибку с UIAlertController
            }
        }
    }
}
