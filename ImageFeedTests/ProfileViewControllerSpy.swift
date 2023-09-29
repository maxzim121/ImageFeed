//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Maksim Zimens on 27.09.2023.
//

import Foundation
import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var urlTest: URL?
    
    func updateAvatar(from url: URL) {
        
    }
    
    func observer() {
        
    }
    
    func updateProfile(name: String, loginName: String, bio: String) {
        
    }
    
    
}
