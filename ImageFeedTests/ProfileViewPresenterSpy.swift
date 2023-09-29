//
//  ProfileViewPresenterSpy.swift
//  ImageFeedProfileTests
//
//  Created by Maksim Zimens on 27.09.2023.
//

import Foundation
import ImageFeed
import UIKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    var presenterViewDidLoadCalled: Bool = false
    
    var alert = UIAlertController()
    
    func setUpProfilePic() {
        
    }
    
    func updateProfileDetails() {
        view?.updateProfile(name: "name", loginName: "loginName", bio: "bio")
    }
    
    func showSplashScreen() {
        
    }
    
    func deleteToken() {
        
    }
    
    func deleteCash() {
        
    }
    
    func showAlert() -> UIAlertController {
        return alert
    }
    
    func exitAccount() {
        
    }
    
    func viewDidLoad() {
        presenterViewDidLoadCalled = true
    }
    
    
}
