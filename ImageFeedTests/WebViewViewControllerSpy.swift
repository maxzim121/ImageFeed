//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Maksim Zimens on 27.09.2023.
//

import Foundation
import ImageFeed
final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadDidCalled: Bool =  false
    
    
    func load(request: URLRequest) {
        loadDidCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
}
