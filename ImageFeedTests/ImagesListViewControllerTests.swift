//
//  ImagesListViewControllerTests.swift
//  ImageFeedTests
//
//  Created by Maksim Zimens on 28.09.2023.
//

@testable import ImageFeed
import XCTest
import Foundation
import UIKit

final class ImagesListTests: XCTestCase {
    
    let vc = ImagesListViewController()
    let service = ImageListService()
    let presenter = ImagesListViewPresenter()
    let presenterSpy = ImagesListViewPresenterSpy()
    
    func testListConfigRan() {
        vc.presenterConfiguration(presenterSpy)
                
        let _ = vc.view
                
        XCTAssertTrue(presenterSpy.imagesListConfigWasCalled)
    }
}
