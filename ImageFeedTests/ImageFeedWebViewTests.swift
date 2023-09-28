//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Maksim Zimens on 27.09.2023.
//
@testable import ImageFeed
import XCTest
import Foundation

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssert(presenter.viewDidLoadCalled)
        
    }
    
    func testPressenterCallsLoadRequest() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let viewController = WebViewViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssert(viewController.loadDidCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssert(shouldHideProgress == false)
    }
    
    func testProgressHiddenWhenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        XCTAssert(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        XCTAssert(urlString.contains(configuration.authURLString))
        XCTAssert(urlString.contains(configuration.accessKey))
        XCTAssert(urlString.contains(configuration.redirectURI))
        XCTAssert(urlString.contains(configuration.accessScope))
        XCTAssert(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [
            URLQueryItem(name: "code", value: "test_code")
        ]
        let url = urlComponents?.url
        
        var answer = authHelper.code(from: url!)
        
        XCTAssertEqual(answer, "test_code")
    }
}
