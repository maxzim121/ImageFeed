import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    
    private var profilePic = UIImageView()
    private var nameLabel = UILabel()
    private var nickNameLabel = UILabel()
    private var userDiscript = UILabel()
    private var exitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProfilePic()
        configureNameLabel()
        configureNickNameLabel()
        configureUserDiscript()
        configureExitButton()
    }
    
    private func configureProfilePic() {
        profilePic.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePic)
        profilePic.image = UIImage(named: "DefaultUserPic")
        NSLayoutConstraint.activate([
            profilePic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profilePic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profilePic.widthAnchor.constraint(equalToConstant: 70),
            profilePic.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.numberOfLines = 1
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profilePic.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureNickNameLabel() {
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameLabel)
        nickNameLabel.text = "@ekaterina_nov"
        
        nickNameLabel.font = UIFont.systemFont(ofSize: 13)
        nickNameLabel.textColor = UIColor(named: "YP Gray")
        NSLayoutConstraint.activate([
            nickNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nickNameLabel.heightAnchor.constraint(equalToConstant: 18),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func configureUserDiscript() {
        userDiscript.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDiscript)
        userDiscript.text = "Hello, world!"
        userDiscript.font = UIFont.systemFont(ofSize: 13)
        userDiscript.textColor = .white
        NSLayoutConstraint.activate([
            userDiscript.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userDiscript.topAnchor.constraint(equalTo:  nickNameLabel.bottomAnchor, constant: 8),
            userDiscript.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func configureExitButton() {
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.setImage(UIImage(named: "ipad.and.arrow.forward"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonDidTap), for: .touchUpInside)
        NSLayoutConstraint.activate([
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profilePic.centerYAnchor)
        ])
    }
    
    @objc
    private func exitButtonDidTap() {
    }
    
}