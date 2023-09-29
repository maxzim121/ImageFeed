//
//  ImagesListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Maksim Zimens on 28.09.2023.
//

import Foundation
import ImageFeed
import UIKit

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    var imagesListConfigWasCalled: Bool = false
    
    func imageListDidTapLike(for cell: ImageFeed.ImagesListCell, indexPath: IndexPath) {
        
    }
    
    func cellHeightCalculator(indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        return CGFloat()
    }
    
    func fetchNextPhotos(indexPath: IndexPath) {
        
    }
    
    func imagesListConfig() {
        imagesListConfigWasCalled = true
    }
    
    func animatedUpdateTableView() {
        
    }
    
    func reloadImageList() {
        
    }
    
    func photosCount() -> Int {
        return 0
    }
    
    func getLargeURL(from indexPath: IndexPath) -> String {
        return ""
    }
    
    func getThumbUrl(indexPath: IndexPath) -> String {
        return ""
    }
    
    func getLike(indexPath: IndexPath) -> Bool {
        return true
    }
    
    func getDate(indexPath: IndexPath) -> Date? {
        return Date()
    }
    
    
}
