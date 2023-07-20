//
//  ElementsHelper.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 19.07.23.
//

import XCTest

class ElementsHelper: XCTest {
    /// Wait until an XCUIElementQuery has at least X number of elements
    ///
    /// - Parameters:
    ///   - elements: XCUIElementQuery that will be polled
    ///   - timeoutValue: How long to wait until the condition is met
    ///   - elementsCount: Minimum number of elements to expect in the XCUIElementQuery
    /// - Returns: Boolean value if the condition was met and the query has at least the X number of elements
    class func waitUntilTableFilled(elements: XCUIElementQuery,
                                    _ timeoutValue: Double,
                                    _ elementsCount: Int = 1) -> Bool {
        let startTime = Date().timeIntervalSince1970
        
        while (Date().timeIntervalSince1970 - startTime) < timeoutValue {
            if elements.count >= elementsCount {
                return true
            }
            usleep(300_000) // 300ms
        }
        return false
    }
    
    /// Performs drag and drop actions on non-hittable elements
    ///
    /// - Parameters:
    ///   - firstElement: The element that will be dragged
    ///   - secondElement: The element which will be used as an end coordinate to drag the first element to
    ///   - pressDuration: How long to press the element to activate the drag and drop functionality before moving it
    class func dragAndDropNonHittable(_ firstElement: XCUIElement, _ secondElement: XCUIElement, _ pressDuration: TimeInterval) {
        let startCoordinate = firstElement.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let endCoordinate = secondElement.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        startCoordinate.press(forDuration: pressDuration, thenDragTo: endCoordinate)
    }
    
    /// Wait until XCUIElement disappears
    ///
    /// - Parameters:
    ///   - element: XCUIElement that will be polled until it disappears
    ///   - timeoutValue: How long to poll the XCUIElement until it disappears
    class func waitUntilElementDisappears(element: XCUIElement, timeoutValue: Double) {
        let startTime = Date().timeIntervalSince1970
        var elementVisible = true
        
        while (Date().timeIntervalSince1970 - startTime) < timeoutValue {
            if !element.exists {
                elementVisible = false
                break
            }
            usleep(300_000) // 300ms
        }
        XCTAssertFalse(elementVisible, "\(element) is still visible after \(timeoutValue) seconds")
    }
    
    /// Validate the relative position of the first element to the second element
    ///
    /// - Parameters:
    ///   - firstElement: The element for which we validate the position
    ///   - secondElement: The element against which we validate the first element position
    ///   - relativePosition: The expected position of the first element relative to the second element
    class func validateElementToElementPosition(firstElement: XCUIElement,
                                                secondElement: XCUIElement,
                                                relativePosition: TestConstants.ElementPosition) -> Bool {
        switch relativePosition {
        case .leftOf:
            return firstElement.frame.maxX <= secondElement.frame.minX

        case .rightOf:
            return firstElement.frame.minX >= secondElement.frame.maxX

        case .above:
            return firstElement.frame.maxY <= secondElement.frame.minY

        case .below:
            return firstElement.frame.minY >= secondElement.frame.maxY
        }
    }
}