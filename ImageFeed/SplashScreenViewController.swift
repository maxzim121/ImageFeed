

import Foundation
import UIKit
import ProgressHUD
import SwiftKeychainWrapper


final class SplashScreenViewController: UIViewController {
    
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private var logoView = UIImageView()
    
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureSplashScreen()
        
//        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token")
        print("так так")
        if let token = KeychainWrapper.standard.string(forKey: "Auth token") {
            print("ВОТ ТУТ ДОЛЖНО БЫТЬ")
            fetchProfile(token: token)
        } else {
            print("ПОЧЕМУУУУУУ")
            switchToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        print("ТАБ БАРА")
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
        present(tabBarController, animated: true)
    }
    
    private func switchToAuthViewController() {
        print("АУНТИФИКАЦИИ")
        let authViewController = UIStoryboard(name: "Main", bundle: .main)
                    .instantiateViewController(identifier: "AuthViewController") as? AuthViewController
        authViewController?.delegate = self
        guard let authViewController = authViewController else { return }
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}

//extension SplashScreenViewController {
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showAuthenticationScreenSegueIdentifier {
//            guard
//                let navigationController = segue.destination as? UINavigationController,
//                let viewController = navigationController.viewControllers[0] as? AuthViewController
//            else { fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)") }
//            viewController.delegate = self
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
//}

extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        print("получаем токен")
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            print("получили токен")
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showNetworkErrorAlert(viewController: self)
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        print("получаем профиль")
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                print("получили знаение прочиля")
                self.profileImageService.fetchProfileImageURL(username: self.profileService.profile.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showNetworkErrorAlert(viewController: self)
                break
                }
            UIBlockingProgressHUD.dismiss()
            }
        }
    
}

extension SplashScreenViewController {
    
    private func showNetworkErrorAlert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default) { [weak self] _ in
            guard let self = self else {return}
            self.performSegue(withIdentifier: self.showAuthenticationScreenSegueIdentifier, sender: nil)
            viewController.present(alert, animated: false)
        }
        
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
    
}

extension SplashScreenViewController {
    
    private func configureSplashScreen() {
        logoView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "YP Black")
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
