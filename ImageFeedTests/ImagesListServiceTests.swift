//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Maksim Zimens on 24.09.2023.
//
@testable import ImageFeed
import XCTest

final class ImageListServiceTests: XCTestCase {

    func testFetchPhotos() throws {
        let service = ImageListService()
        
        let expectation = self.expectation(description: "Wait for notification")
        
        NotificationCenter.default.addObserver(forName: ImageListService.DidChangeNotification,
                                               object: nil,
                                               queue: .main) { _ in
            expectation.fulfill()
        }
        
        service.fetchPhotosNextPage()

        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }

    
}
