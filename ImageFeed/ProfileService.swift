import Foundation
import UIKit

struct ProfileResult: Codable {
    var username: String
    var firstName: String
    var lastName: String
    var bio: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile{
    var username: String
    var name: String
    var loginName: String
    var bio: String
}

final class ProfileService {
    
    var profile = Profile(username: "",
                          name: "",
                          loginName: "",
                          bio: "")
    
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        
        if task != nil { return }
        
        var request = profileInfoRequest()
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        task = urlSession.object(urlSession: urlSession, for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else {return}
                switch result {
                case .success(let body):
                    let username = body.username
                    let name = "\(body.firstName) \(body.lastName)"
                    let loginName = "@\(body.username)"
                    let bio = body.bio
                    self.profile = Profile(username: username,
                                           name: name,
                                           loginName: loginName,
                                           bio: bio)
                    completion(.success(self.profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func profileInfoRequest() -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET")
    }
    
}
