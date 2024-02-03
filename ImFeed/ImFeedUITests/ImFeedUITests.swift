//
//  ImFeedUITests.swift
//  ImFeedUITests
//
//  Created by Юрий Клеймёнов on 03/02/2024.
//

import XCTest

final class ImFeedUITests: XCTestCase {
    private let app = XCUIApplication() 
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        
    }
    
    func testFeed() throws {
        
    }
    
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}
