//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Maksim Zimens on 27.09.2023.
//

import Foundation
import Kingfisher
import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func setUpProfilePic()
    func updateProfileDetails()
    func showSplashScreen()
    func deleteToken()
    func deleteCash()
    func showAlert() -> UIAlertController
    func exitAccount()
    func viewDidLoad()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    private var tokenStorage = OAuth2TokenKeychainStorage()
    
    func viewDidLoad() {
        updateProfileDetails()
        setUpProfilePic()
    }
    
    func exitAccount() {
        deleteCash()
        deleteToken()
        showSplashScreen()
    }
    
    func showSplashScreen() {
        guard let window = UIApplication.shared.windows.first else { return }
        let splashScreenViewController = SplashScreenViewController()
        window.rootViewController = splashScreenViewController
    }
    
    func deleteToken() {
        tokenStorage.removeSuccessful()
    }
    
    func deleteCash() {
        ExitAccountService.shared.clean()
    }
    
    func showAlert() -> UIAlertController {
        let alertViewController = UIAlertController(title: "Пока, пока!",
                                                    message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let actionNet = UIAlertAction(title: "Нет", style: .default) { _ in
            alertViewController.dismiss(animated: true)
        }
        let actionDa = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.exitAccount()
        }
        alertViewController.addAction(actionDa)
        alertViewController.addAction(actionNet)
        return alertViewController
    }
    
    
    func updateProfileDetails() {
        let profile = ProfileService.shared.profile
        guard
            let name = profile.name,
            let bio = profile.bio else {return}
        let loginName = profile.loginName
        view?.updateProfile(name: name, loginName: loginName, bio: bio)
    }
    
    
    func setUpProfilePic() {
        guard
            let profileImageUrl = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageUrl) else { return }
        view?.updateAvatar(from: url)
    }
    
    
}
