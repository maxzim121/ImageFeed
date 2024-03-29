
import Foundation

struct OAuthTokenResponseBody: Codable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
