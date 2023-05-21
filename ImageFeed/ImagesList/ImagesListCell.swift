//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Maksim Zimens on 10.05.2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormater: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var imageShown: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    
    
    public func cellSettings(imageNeeded: UIImage, indexPath: IndexPath) {
        imageShown.image = imageNeeded
        
        if indexPath.row % 2 == 0 {
            likeButton.imageView?.image = UIImage(named: "LikeDefault")
        } else {
            likeButton.imageView?.image = UIImage(named: "Like")
        }
        dateLabel.text = dateFormater.string(from: Date())
    }
    
    
}
