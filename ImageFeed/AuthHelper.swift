//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Maksim Zimens on 27.09.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    private let constaints = AuthConfiguration.standard
    
    func authRequest() -> URLRequest {
        
        let request = URLRequest(url: authURL())
        return request
    }
    func authURL() -> URL {
        var urlComponents = URLComponents(string: constaints.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: constaints.accessKey),
            URLQueryItem(name: "redirect_uri", value: constaints.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: constaints.accessScope)
        ]
        return urlComponents.url!
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
}
