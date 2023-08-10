//
//  InteractionHelper.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

class Interaction {
    /// Press the device home button
    static func pressHomeButton() {
        XCUIDevice.shared.press(.home)
    }
    
    /// Performs drag and drop action relative to two elements
    ///
    /// - Parameters:
    ///   - firstElement: The element that will be dragged
    ///   - secondElement: The element which will be used as an end coordinate to drag the first element to
    ///   - pressDuration: How long to press the element to activate the drag and drop functionality before moving it
    static func dragAndDrop(_ firstElement: XCUIElement, _ secondElement: XCUIElement, _ pressDuration: TimeInterval = 0.5) {
        let startCoordinate = firstElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let endCoordinate = secondElement.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        startCoordinate.press(forDuration: pressDuration, thenDragTo: endCoordinate)
    }
    
    /// Gentler swipe alternative allowing swipe in specified XCUIElement
    ///
    /// **Examples**
    ///  ```
    ///  - performGentleSwipe(app.scrollViews["test"], TestConstants.Direction.up, TestConstants.SwipeAdjustment.normal): This will perform a gentle swipe up in the targeted scrollview
    ///  ```
    /// - Parameters:
    ///   - element: XCUIElement as target for the gesture
    ///   - direction: The direction of the swipe gesture, refer to `TestConstants` class for available options
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to `TestConstants` class for available options
    static func performGentleSwipe(_ element: XCUIElement, _ direction: TestConstants.Direction, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal) {
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
    
    /// Gentler swipe alternative, swiping the AUT directly
    ///
    /// **Examples**
    ///  ```
    ///  - performGentleSwipe(TestConstants.Direction.up, TestConstants.SwipeAdjustment.normal): This will perform a gentle swipe up in the targeted scrollview
    ///  ```
    /// - Parameters:
    ///   - element: XCUIElement as target for the gesture
    ///   - direction: The direction of the swipe gesture, refer to `TestConstants` class for available options
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to `TestConstants` class for available options
    static func performGentleSwipe(_ direction: TestConstants.Direction, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal) {
        performGentleSwipe(BaseTest().getApp(), direction, swipeAdjustment)
    }
    
    /// Perform multiple gentle swipes
    ///
    /// **Examples**
    ///  ```
    ///  - performGentleSwipes(app.scrollViews["test"], TestConstants.Direction.up, TestConstants.SwipeAdjustment.normal, 3): This will perform 3 gentle swipes in the targeted scrollview
    ///  ```
    /// - Parameters:
    ///   - element: XCUIElement as target for the gesture
    ///   - direction: The direction of the swipe gesture, refer to `TestConstants` class for available options
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to `TestConstants` class for available options
    ///   - count: Number of gentle swipes to perform
    static func performGentleSwipes(_ element: XCUIElement, _ direction: TestConstants.Direction, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal, _ count: Int) {
        for _ in 1...count {
            performGentleSwipe(element, direction, swipeAdjustment)
        }
    }
    
    ///  Gently swipe until a condition is met, allows to swipe in a specific element
    ///
    ///  **Examples**
    ///  ```
    ///  - performGentleSwipeUntil(app.scrollViews["test"], TestConstants.Direction.up, 3, until: elementUnderTest.exists): This will swipe up in the app or element 3 times and check if another element exists each time
    ///  ```
    /// - Parameters:
    ///   - swipeDirection: The direction of the swipe gesture, refer to `TestConstants` class for available options
    ///   - maxNumberOfSwipes:  The number of swipes to perform before failing
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to `TestConstants` or provide your own
    ///   - until: Condition that needs to be met while swiping - `element.exists` for example
    static func performGentleSwipeUntil(_ element: XCUIElement, _ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal, until condition: @autoclosure () -> Bool ) {
        var success = false
        for _ in 1...maxNumberOfSwipes {
            if condition() {
                success = true
                break
            }
            performGentleSwipe(element, swipeDirection, swipeAdjustment)
            
            // to avoid performing an extra scroll when the condition fails because the previous scroll didn't end yet
            sleep(1)
        }
        XCTAssertTrue(success, "Condition was not satisfied swiping \(maxNumberOfSwipes) times in \(self) with swipe adjustment \(swipeAdjustment)")
    }
    
    /// Swipes in app/element until a condition is met
    ///
    /// **Examples:**
    /// ```
    /// - performSwipeUntil(TestConstants.Direction.up, 3, until: elementUnderTest.exists): This will swipe up in the app or element 3 times and check if another element exists each time
    /// ```
    /// - Parameters:
    ///   - swipeDirection: The direction of the swipe gesture, refer to `TestConstants` class for available options
    ///   - maxNumberOfSwipes: The number of swipes to perform before failing
    ///   - until: Condition that needs to be met while swiping - `element.exists` for example
    static func performSwipeUntil(_ element: XCUIElement, _ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, until condition: @autoclosure () -> Bool) {
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
            
            // to avoid performing an extra scroll when the condition fails because the previous scroll didn't end yet
            sleep(1)
        }
        XCTAssertTrue(success, "Condition was not satisfied swiping \(maxNumberOfSwipes) times in \(self)")
    }
}
