import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: "Rd1Z3Fvp2rjGiV3pCmtBR8nwtnp96Bi_X-qYtHaFUgM",
                                     secretKey: "2NmCDQabzbguyPDRRPj5GN9QphfoBv3Nx9lnJ9sEplM",
                                     redirectURI: "urn:ietf:wg:oauth:2.0:oob",
                                     accessScope: "public+read_user+write_likes",
                                     authURLString: "https://unsplash.com/oauth/authorize",
                                     defaultBaseURL: URL(string: "https://api.unsplash.com")!)
        }
    
}
