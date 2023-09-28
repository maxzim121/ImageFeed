//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Maksim Zimens on 28.09.2023.
//
import XCTest

final class ImageFeedUITests: XCTestCase {

    private let app = XCUIApplication()
        
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        app/*@START_MENU_TOKEN@*/.staticTexts["Войти"]/*[[".buttons[\"Войти\"].staticTexts[\"Войти\"]",".staticTexts[\"Войти\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let webView = app.webViews["UnsplashWebView"]
        webView.waitForExistence(timeout: 25)
        let webViewsQuery = app.webViews.webViews.webViews
        let connectImagefeedUnsplashUnsplashElement = webViewsQuery.otherElements["Connect ImageFeed + Unsplash | Unsplash"]
        let loginTextField = connectImagefeedUnsplashUnsplashElement.children(matching: .textField).element
        let passwordTextField = connectImagefeedUnsplashUnsplashElement.children(matching: .secureTextField).element
        
        loginTextField.tap()
        sleep(1)
        loginTextField.typeText("zimensm12@gmail.com")
        app.children(matching: .window).firstMatch.tap()
        sleep(1)
        passwordTextField.tap()
        sleep(1)
        passwordTextField.typeText("12563478As")
        sleep(1)
        webViewsQuery/*@START_MENU_TOKEN@*/.buttons["Login"]/*[[".otherElements[\"Connect ImageFeed + Unsplash | Unsplash\"].buttons[\"Login\"]",".buttons[\"Login\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
               
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        firstCell.swipeUp()
        sleep(3)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["LikeDefault"].tap()
        sleep(5)
            
        cellToLike.buttons["LikeDefault"].tap()
        sleep(5)
        
        cellToLike.tap()
        sleep(7)
                
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
                
        image.pinch(withScale: 3, velocity: 1)
        sleep(1)
        image.pinch(withScale: 0.5, velocity: -1)
        sleep(1)
                
        app.buttons["Backward"].tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
           
        XCTAssertTrue(app.staticTexts["Maksim Zimens"].exists)
        XCTAssertTrue(app.staticTexts["@maxzim121"].exists)
            
        app.buttons["ipad.and.arrow"].tap()
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
