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
    class func performGentleSwipe(_ direction: TestConstants.Direction, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal) {
        let pressDuration: TimeInterval = 0.05
        let swipeOffset = swipeAdjustment - 0.5
        
        let center = XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        let target: XCUICoordinate
        
        switch direction {
        case .up:
            
            target = center.withOffset(CGVector(dx: 0.0, dy: -swipeOffset))
            
        case .down:
            target = center.withOffset(CGVector(dx: 0.0, dy: swipeOffset))
            
        case .left:
            target = center.withOffset(CGVector(dx: -swipeOffset, dy: 0.0))
            
        case .right:
            target = center.withOffset(CGVector(dx: swipeOffset, dy: 0.0))
        }
        
        center.press(forDuration: pressDuration, thenDragTo: target)
    }
    
    ///  Swipe until a condition is met
    ///
    /// - Parameters:
    ///   - swipeDirection: The direction of the swipe gesture, refer to TestConstants class for available options
    ///   - maxNumberOfSwipes: The number of swipes to perform before failing
    ///   - swipeAdjustment: CGFloat value for the size of the swipe gesture, refer to TestConstants class for available options
    ///   - until: Condition that needs to be met while swiping - element.exists for example
    /// - Returns: Boolean value if the condition was met while swiping
    class func performGentleSwipeUntil(_ swipeDirection: TestConstants.Direction, _ maxNumberOfSwipes: UInt, _ swipeAdjustment: CGFloat = TestConstants.SwipeAdjustment.normal, until condition: @autoclosure () -> Bool ) -> Bool {
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
}
