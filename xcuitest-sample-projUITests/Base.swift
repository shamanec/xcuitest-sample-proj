//
//  BaseTest.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

class Base: XCTestCase {
    private let defaultLoadingTime = 30.0
    
    public let app = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    // Below for the developed app target
    // let app = XCUIApplication()
    
    override func setUp() {
        // Fail-fast tests
        continueAfterFailure = false
        // Start the AUT
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    public func waitForPageLoading(element: XCUIElement) {
        XCTAssertTrue(element.waitForExistence(timeout: defaultLoadingTime))
    }
}
