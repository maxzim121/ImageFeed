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
    
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var imageShown: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    
    
    
}
