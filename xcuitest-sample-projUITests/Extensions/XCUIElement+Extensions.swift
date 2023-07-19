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
    
    ///  Swipe until a condition is met, allows to swipe in a specific element
    ///
    /// - Parameters:
    ///   - swipeDirection: The direction of the swipe gesture, refer to TestConstants class for available options
    ///   - maxNumberOfSwipes: The number of swipes to perform before failing
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to TestConstants class for available options
    ///   - until: Condition that needs to be met while swiping - element.exists for example
    /// - Returns: Boolean value if the condition was met while swiping
    func performGentleSwipeUntil(_ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal, until condition: @autoclosure () -> Bool ) -> Bool {
        var success = false
        for _ in 1...maxNumberOfSwipes {
            guard !condition() else {
                success = true
                break
            }
            performGentleSwipe(swipeDirection, swipeAdjustment)
            // to avoid perform an extra scroll when the conditions fails since the previous scroll didn't end yet
            sleep(1)
        }
        return success
    }
    
    /// Gentler swipe alternative to the integrated swipe, allows to swipe inside a specific element
    ///
    /// - Parameters:
    ///   - direction: The direction of the swipe gesture, refer to TestConstants class for available options
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to TestConstants class for available options
    func performGentleSwipe(_ direction: TestConstants.Direction, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal) {
        let startCoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endCoordinate: XCUICoordinate
        
        switch direction {
        case .up:
            endCoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.5 - swipeAdjustment))
        case .down:
            endCoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.5 + swipeAdjustment))
        case .left:
            endCoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5 - swipeAdjustment, dy: 0.0))
        case .right:
            endCoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.5 + swipeAdjustment, dy: 0.0))
        }
        
        startCoordinate.press(forDuration: 0.05, thenDragTo: endCoordinate)
    }
    
    /// Swipes in app or container until a condition is met
    ///
    /// **Examples:**
    /// ```
    /// - swipeUntil(TestConstants.Direction.up, 3, until: elementUnderTest.exists): This will swipe up in the app or element 3 times and check if another element exists each time
    /// ```
    /// - Parameters:
    ///   - swipeDirection: The direction of the swipe gesture, refer to TestConstants class for available options
    ///   - maxNumberOfSwipes: The number of swipes to perform before failing
    ///   - until: Condition that needs to be met while swiping - element.exists for example
    /// - Returns: Boolean value if the element was found while swiping in the container
    func swipeUntil(_ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, until condition: @autoclosure () -> Bool) -> Bool {
        var success = false
        for _ in 1...maxNumberOfSwipes {
            if condition() {
                success = true
                break
            }
            switch swipeDirection {
            case .up:
                self.swipeUp()
            case .down:
                self.swipeDown()
            case .left:
                self.swipeLeft()
            case .right:
                self.swipeRight()
            }
            
            // to avoid perform an extra scroll when the conditions fails since the previous scroll didn't end yet
            sleep(1)
        }
        return success
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
