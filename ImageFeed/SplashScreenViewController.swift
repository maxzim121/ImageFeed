

import Foundation
import UIKit
import ProgressHUD
import SwiftKeychainWrapper


final class SplashScreenViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private var logoView = UIImageView()
    
    private var keyChainStorage = OAuth2TokenKeychainStorage()
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIBlockingProgressHUD.show()
        if let token = keyChainStorage.getToken() {
            fetchProfile(token: token)
            UIBlockingProgressHUD.dismiss()
        } else {
            UIBlockingProgressHUD.dismiss()
            switchToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        configureSplashScreen()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        present(tabBarController, animated: true)
    }
    
    private func switchToAuthViewController() {
        let authViewController = UIStoryboard(name: "Main", bundle: .main)
                    .instantiateViewController(identifier: "AuthViewController") as? AuthViewController
        authViewController?.delegate = self
        guard let authViewController = authViewController else { return }
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true){ [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
}

extension SplashScreenViewController {
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.profileImageService.fetchProfileImageURL(username: self.profileService.profile.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showNetworkErrorAlert()
                break
                }
            UIBlockingProgressHUD.dismiss()
            }
        }
}

extension SplashScreenViewController {
    
    private func showNetworkErrorAlert() {
        let vc: UIViewController = self.presentedViewController ?? self
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default) { [weak self] _ in
            guard let self = self else {return}
            vc.dismiss(animated: true)
            self.switchToAuthViewController()
        }
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    
}

extension SplashScreenViewController {
    
    private func configureSplashScreen() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .ypBlack
        view.addSubview(logoView)
        logoView.image = UIImage(named: "Logo")
        NSLayoutConstraint.activate([
            logoView.heightAnchor.constraint(equalToConstant: 78),
            logoView.widthAnchor.constraint(equalToConstant: 75),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
