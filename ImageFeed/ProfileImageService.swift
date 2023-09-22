
import Foundation
import UIKit
import SwiftKeychainWrapper

struct AllProfileImageResult: Codable {
    var allImages: ProfileImageResult
    
    enum CodingKeys: String, CodingKey {
        case allImages = "profile_image"
    }
}

struct ProfileImageResult: Codable {
    var small: String
    var medium: String
    var large: String
}

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    private var profileService = ProfileService.shared
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let token = KeychainWrapper.standard.string(forKey: "Auth token") else { return }
        
        var request = profileImageRequest(username: username)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = urlSession.object(urlSession: urlSession, for: request) { [weak self] (result: Result<AllProfileImageResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                print("получаем фотку")
                switch result {
                case .success(let body):
                    let allImages = body.allImages
                    self.avatarURL = allImages.small
                    guard let avatarURL = self.avatarURL else {
                        return
                    }
                    completion(.success(avatarURL))
                    print(avatarURL)
                    NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification,
                                                    object: self,
                                                    userInfo: ["URL": avatarURL])
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func profileImageRequest(username: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/users/\(username)",
            httpMethod: "GET")
    }
    
}
