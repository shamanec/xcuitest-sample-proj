//
//  xcuitest_sample_projUITests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

final class xcuitest_sample_projUITests: Base {
    
    func testGentleSwipeUntil() {
        print(app.debugDescription)
        InteractionHelper.performGentleSwipeUntil(app.scrollViews["carousel-view"], .left, 5, until: app.staticTexts["carousel_item10"].exists)
    }
    
    func testGenericSwipeUntil() {
        InteractionHelper.performSwipeUntil(app.scrollViews["carousel-view"], .left, 3, until: app.staticTexts["carousel_item10"].exists)
    }
    
    func testElementToElementPositionPass() {
        // This should pass
        ElementsHelper.validateElementToElementPosition(firstElement: app.staticTexts["carousel_item2"], secondElement: app.staticTexts["carousel_item3"], relativePosition: .leftOf)
    }
    
    func testElementToElementPositionFail() {
        // This should fail
        ElementsHelper.validateElementToElementPosition(firstElement: app.staticTexts["carousel_item2"], secondElement: app.staticTexts["carousel_item3"], relativePosition: .rightOf)
    }
    
    func testElementDisappearsSameScreen() {
        app.buttons["Disappear"].tap()
        let disappearingButton = app.buttons.element(matching: .button, identifier: "disappearing-button")
        XCTAssertTrue(disappearingButton.isVisible)
        disappearingButton.tap()
        ElementsHelper.waitUntilElementDisappears(element: disappearingButton, timeoutValue: 6)
        XCTAssertFalse(disappearingButton.isVisible)
    }
    
    func testElementNotExistChangeScreens() {
        app.buttons["Disappear"].tap()
        let button = app.buttons.element(matching: .button, identifier: "disappearing-button")
        XCTAssertTrue(button.isVisible)
        app.buttons["Carousel"].tap()
        XCTAssertFalse(button.exists)
    }
    
    func testWaitForQueryHaveNumberOfElements() {
        app.buttons["Loading"].tap()
        let elements = app.staticTexts.matching(identifier: "loaded-el")
        // Wait for 11 seconds to have 5 elements, should pass
        ElementsHelper.waitUntilTableFilled(elements: elements, 11, TestConstants.Timeout.medium)
        // Wait 5 more seconds to have 6 elements, should fail because only 5 in total will be loaded
        ElementsHelper.waitUntilTableFilled(elements: elements, 6, TestConstants.Timeout.short)
    }
}
