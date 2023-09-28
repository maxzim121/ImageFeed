//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Maksim Zimens on 28.09.2023.
//

import Foundation
import UIKit
public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    func imageListDidTapLike(for cell: ImagesListCell, indexPath: IndexPath)
    func cellHeightCalculator(indexPath: IndexPath, tableView: UITableView) -> CGFloat
    func fetchNextPhotos(indexPath: IndexPath)
    func imagesListConfig()
    func animatedUpdateTableView()
    func reloadImageList()
    func photosCount() -> Int
    func getLargeURL(from indexPath: IndexPath) -> String
    func getThumbUrl(indexPath: IndexPath) -> String
    func getLike(indexPath: IndexPath) -> Bool
    func getDate(indexPath: IndexPath) -> Date?
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol{
    var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    private let imageListService = ImageListService.shared
    
    func fetchNextPhotos(indexPath: IndexPath) {
        if indexPath.row + 1 == imageListService.photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func animatedUpdateTableView() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
            }
        }
    
    func cellHeightCalculator(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func imagesListConfig() {
        imageListService.fetchPhotosNextPage()
        view?.addingObserver()
        }
    func reloadImageList() {
        imageListService.lastLoadedPage = 0
        imageListService.photos = []
    }

    func getLargeURL(from indexPath: IndexPath) -> String{
        print("ВЫЗВАЛИ",photos[indexPath.row].largeImageURL)
        return photos[indexPath.row].largeImageURL
        }
    
    func photosCount() -> Int{
        return photos.count
    }
    
    func imageListDidTapLike(for cell: ImagesListCell, indexPath: IndexPath) {
        imageListService.changeLike(photoId: photos[indexPath.row].id, isLike: photos[indexPath.row].isLiked) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(_):
                self.photos = self.imageListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self.view?.showErrorAlert()
            }
        }
    }
    
    func getThumbUrl(indexPath: IndexPath) -> String {
        return photos[indexPath.row].thumbImageURL
    }
    
    func getDate(indexPath: IndexPath) -> Date? {
        return photos[indexPath.row].createdAt
    }
    
    func getLike(indexPath: IndexPath) -> Bool {
        return photos[indexPath.row].isLiked
    }
    
    
}
