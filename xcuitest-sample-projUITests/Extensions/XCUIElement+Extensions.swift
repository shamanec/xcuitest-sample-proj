//
//  XCUIElement+Extensions.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

extension XCUIElement {
    /// Get the text from the value property of an element
    var textFromValue: String? { value as? String }
    
    /// Performs tap on non-hittable element by coordinates
    func tapNonHittable() {
        let coordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        coordinate.tap()
    }
    
//    /**
//     You can use this function to clear the typed text from a text field using the keyboard
//     It will try to focus the field if not focused already, will not work on simulator without actual keyboard displayed during execution
//     */
//    func clearTextField() {
//        let startTime = NSDate().timeIntervalSince1970
//        let deleteButton = XCUIApplication().keys.matching(identifier: "delete").element(boundBy: 0)
//        XCTAssertTrue(waitForExistence(timeout: 3.0))
//        if !self.debugDescription.contains("Keyboard Focused") {
//            tap()
//        }
//        while (NSDate().timeIntervalSince1970 - startTime) < 10 {
//            if XCUIApplication().keyboards.count >= 1 && deleteButton.isHittable {
//                break
//            }
//            usleep(300_000) // 300ms
//        }
//        doubleTap()
//        deleteButton.tap()
//        XCUIApplication().toolbars.buttons["Done"].tap()
//    }
}
