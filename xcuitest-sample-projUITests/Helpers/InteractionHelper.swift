//
//  InteractionHelper.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

class InteractionHelper {

    
    /// Gentler swipe alternative to the integrated swipe
    ///
    /// - Parameters:
    ///   - direction: The direction of the swipe gesture, refer to TestConstants class for available options
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to TestConstants class for available options
    class func performGentleSwipe(_ element: XCUIElement, _ direction: TestConstants.Direction, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal) {
        let startCoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endCoordinate: XCUICoordinate
        
        switch direction {
        case .up:
            endCoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.5 - swipeAdjustment))
        case .down:
            endCoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.5 + swipeAdjustment))
        case .left:
            endCoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5 - swipeAdjustment, dy: 0.0))
        case .right:
            endCoordinate = element.coordinate(withNormalizedOffset: CGVector(dx: 0.5 + swipeAdjustment, dy: 0.0))
        }
        
        startCoordinate.press(forDuration: 0.05, thenDragTo: endCoordinate)
    }
    
    ///  Swipe until a condition is met, allows to swipe in a specific element
    ///
    /// - Parameters:
    ///   - swipeDirection: The direction of the swipe gesture, refer to TestConstants class for available options
    ///   - maxNumberOfSwipes: The number of swipes to perform before failing
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to TestConstants class for available options
    ///   - until: Condition that needs to be met while swiping - element.exists for example
    /// - Returns: Boolean value if the condition was met while swiping
    class func performGentleSwipeUntil(_ element: XCUIElement, _ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal, until condition: @autoclosure () -> Bool ) {
        var success = false
        for _ in 1...maxNumberOfSwipes {
            guard !condition() else {
                success = true
                break
            }
            performGentleSwipe(element, swipeDirection, swipeAdjustment)
            // to avoid perform an extra scroll when the conditions fails since the previous scroll didn't end yet
            sleep(1)
        }
        XCTAssertTrue(success, "Condition was not satisfied swiping \(maxNumberOfSwipes) times in \(self) with swipe adjustment \(swipeAdjustment)")
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
    class func performSwipeUntil(_ element: XCUIElement, _ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, until condition: @autoclosure () -> Bool) {
        var success = false
        for _ in 1...maxNumberOfSwipes {
            if condition() {
                success = true
                break
            }
            switch swipeDirection {
            case .up:
                element.swipeUp()
            case .down:
                element.swipeDown()
            case .left:
                element.swipeLeft()
            case .right:
                element.swipeRight()
            }
            
            // to avoid perform an extra scroll when the conditions fails since the previous scroll didn't end yet
            sleep(1)
        }
        XCTAssertTrue(success, "Condition was not satisfied swiping \(maxNumberOfSwipes) times in \(self)")
    }
}
