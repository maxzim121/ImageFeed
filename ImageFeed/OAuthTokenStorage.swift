//
//  File.swift
//  ImageFeed
//
//  Created by Maksim Zimens on 21.07.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let bearerToken = ""
    
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: bearerToken)
        }
        set {
            userDefaults.set(newValue, forKey: bearerToken)
        }
    }
}
