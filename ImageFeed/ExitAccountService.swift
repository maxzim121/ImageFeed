//
//  ExitAccountService.swift
//  ImageFeed
//
//  Created by Maksim Zimens on 25.09.2023.
//

import Foundation
import SwiftKeychainWrapper
import WebKit

final class ExitAccountService {
    
    static let shared = ExitAccountService()
    
    func clean() {
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
}
