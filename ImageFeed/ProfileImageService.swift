
import Foundation
import UIKit

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
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var token = OAuth2TokenKeychainStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    private var profileService = ProfileService.shared
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let bearerToken = token.getToken() else { return }
        
        var request = profileImageRequest(username: username)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        
        task = urlSession.object(urlSession: urlSession, for: request) { [weak self] (result: Result<AllProfileImageResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let body):
                    let allImages = body.allImages
                    self.avatarURL = allImages.small
                    guard let avatarURL = self.avatarURL else {
                        return
                    }
                    completion(.success(avatarURL))
                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification,
                                                    object: self,
                                                    userInfo: ["listPhoto": avatarURL])
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
