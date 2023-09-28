//
//  ImageFeedProfileTests.swift
//  ImageFeedProfileTests
//
//  Created by Maksim Zimens on 27.09.2023.
//
@testable import ImageFeed
import XCTest
import Foundation

final class ProfileTests: XCTestCase {
    
    func testViewControllerCalledPresenterViewDidLoad() {
        
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(presenter)
        
        _ = viewController.view
        
        XCTAssert(presenter.presenterViewDidLoadCalled)

        
    }
    
    func testProfileDataUpdate() {
        
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.configure(presenter)
        
        presenter.updateProfileDetails()
        
        XCTAssertEqual(viewController.nameLabel.text, "name")
        XCTAssertEqual(viewController.userDiscript.text, "bio")
        XCTAssertEqual(viewController.nickNameLabel.text, "loginName")

        
    }

}

