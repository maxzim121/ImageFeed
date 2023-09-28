import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol? {get set}
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func addingObserver()
    func showErrorAlert()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var dateFormater = FormatDate()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListViewPresenter()
        presenter?.view = self
        presenter?.reloadImageList()
        presenter?.imagesListConfig()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            guard let urlString = presenter?.getLargeURL(from: indexPath) else {return}
            viewController.urlString = urlString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    func presenterConfiguration(_ presenter: ImagesListViewPresenterProtocol) {
            self.presenter = presenter
            self.presenter?.view = self
        }

}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter = self.presenter else {return CGFloat()}
        return presenter.cellHeightCalculator(indexPath: indexPath, tableView: tableView)
    }

}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = self.presenter else {return 0}
        return presenter.photosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        let date = presenter?.getDate(indexPath: indexPath)
        guard
            let urlString = presenter?.getThumbUrl(indexPath: indexPath),
            let like = presenter?.getLike(indexPath: indexPath),
            let url = URL(string: urlString) else { return imageListCell}
        imageListCell.imageShown.kf.indicatorType = .activity
        imageListCell.imageShown.kf.setImage(with: url,placeholder: UIImage(named: "placeholder")) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        
        imageListCell.dateLabel.text = dateFormater.setupUIDateString(date: date)
        imageListCell.setIsLiked(isLiked: like)
        return imageListCell
    }
}

extension ImagesListViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchNextPhotos(indexPath: indexPath)
    }
    
}

extension ImagesListViewController {
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    func addingObserver() {
        setUpTableView()
        imageListServiceObserver = NotificationCenter.default
                .addObserver(forName: ImageListService.didChangeNotification,
                             object: nil,
                             queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.presenter?.animatedUpdateTableView()
                }
            presenter?.animatedUpdateTableView()
        }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Ну удалось установить лайк!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        UIBlockingProgressHUD.show()
        presenter?.imageListDidTapLike(for: cell, indexPath: indexPath)
    }
}

