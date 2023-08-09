//
//  ElementsHelper.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 19.07.23.
//

import XCTest

class Elements {
    /// Validate the relative position of the first element to the second element
    ///
    /// - Parameters:
    ///   - firstElement: The element for which we validate the position
    ///   - secondElement: The element against which we validate the first element position
    ///   - relativePosition: The expected position of the first element relative to the second element
    static func validateElementToElementPosition(_ firstElement: XCUIElement,
                                                _ secondElement: XCUIElement,
                                                _ relativePosition: TestConstants.ElementPosition) {
        var result = false
        switch relativePosition {
        case .leftOf:
            result = firstElement.frame.maxX <= secondElement.frame.minX

        case .rightOf:
            result = firstElement.frame.minX >= secondElement.frame.maxX

        case .above:
            result = firstElement.frame.maxY <= secondElement.frame.minY

        case .below:
            result = firstElement.frame.minY >= secondElement.frame.maxY
        }
        XCTAssertTrue(result, "\(firstElement) is not in `\(relativePosition)` relative position to \(secondElement)")
    }
    
    /// Set a slider element to specific value when `adjust(toNormalizedSliderPosition: value)` doesn't work
    /// The adjustment is based on the slider coordinates, absolute fidelity is not guaranteed.
    static func setSlider(_ element: XCUIElement, _ value: CGFloat) {
        let start = element.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.0))
        let end = element.coordinate(withNormalizedOffset: CGVector(dx: value, dy: 0.0))
        start.press(forDuration: 0.05, thenDragTo: end)
    }
    
    /// Set a picker to a specific value
    static func setPickerValue(_ element: XCUIElement, _ value: String) {
        element.adjust(toPickerWheelValue: value)
    }
    
    // MARK: - Wait functions
    
    /// Wait for element to exist with XCUITest supplied `waitForExistence()`
    static func waitForElement(_ element: XCUIElement, _ timeoutValue: Double) -> Bool {
        return element.waitForExistence(timeout: timeoutValue)
    }
    
    /// Wait until an XCUIElementQuery has at least X number of elements - polls each 300ms for the supplied timeout duration
    ///
    /// - Parameters:
    ///   - elements: XCUIElementQuery that will be polled
    ///   - elementsCount: Minimum number of elements to expect in the XCUIElementQuery
    ///   - timeoutValue: How long to wait until the condition is met
    /// - Returns: Boolean value if the condition was met and the query has at least the X number of elements
    static func waitUntilTableFilled(_ elements: XCUIElementQuery,
                                    _ elementsCount: Int = 1,
                                    _ timeoutValue: Double = TestConstants.Timeout.medium) {
        var result = false
        let startTime = Date().timeIntervalSince1970
        
        while (Date().timeIntervalSince1970 - startTime) < timeoutValue {
            if elements.count >= elementsCount {
                result = true
                break
            }
            usleep(300_000)
        }
        XCTAssertTrue(result, "XCUIElementQuery was not filled with \(elementsCount) elements in \(timeoutValue) seconds")
    }
    
    // Can be faster than other approaches because XCUITest supplied `waitForExistence()` and `XCTWaiter` first wait a second and then perform a check
    /// Wait for element to exist polling for the supplied timeout duration.
    static func waitForElementExistence(_ element: XCUIElement, _ timeoutValue: Double, _ exists: Bool, _ pollInterval: UInt32 = 200_000) {
        var result = false
        let startTime = Date().timeIntervalSince1970
        
        while (Date().timeIntervalSince1970 - startTime) < timeoutValue {
            if element.exists == exists {
                result = true
                break
            }
            usleep(pollInterval)
        }
        XCTAssertTrue(result, "Element \(exists ? "does not exist" : "exists") after \(timeoutValue) seconds")
    }
    
    /// Wait for element to become hittable
    static func waitForElementHittable(_ element: XCUIElement, _ timeoutValue: Double, _ hittable: Bool) {
        let predicate = "hittable == \(String(hittable))"
        let isDisplayedPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: isDisplayedPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element is hittable after \(timeoutValue) seconds or does not exist")
    }
    
    /// Wait for element to become enabled
    static func waitForElementEnabled(_ element: XCUIElement, _ timeoutValue: Double, _ enabled: Bool) {
        let predicate = "isEnabled == \(String(enabled))"
        let isEnabledPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: isEnabledPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element is not enabled after \(timeoutValue) seconds or does not exist")
    }
    
    /// Wait for element to exist
    static func waitForElementExistenceAlt(_ element: XCUIElement, _ timeoutValue: Double, _ existence: Bool) {
        let predicate = "exists == \(String(existence))"
        let existsPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: existsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element does not exist after \(timeoutValue) seconds")
    }
    
    /// Wait for element label to equal exact string
    static func waitForElementLabelToBe(_ element: XCUIElement, _ timeoutValue: Double, _ label: String) {
        let predicate = "label == '\(label)'"
        let labelEqualsPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: labelEqualsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element label value is not '\(label)' after \(timeoutValue) seconds or does not exist")
    }
    
    /// Wait for element label to contain a string
    static func waitForElementLabelToContain(_ element: XCUIElement, _ timeoutValue: Double, _ label: String) {
        let predicate = "label == '\(label)'"
        let labelEqualsPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: labelEqualsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element label value does not contain '\(label)' after \(timeoutValue) seconds or does not exist")
    }
    
    /// Wait for element value to contain a specific string
    static func waitForElementValueContains(_ element: XCUIElement, _ timeoutValue: Double, _ value: String) {
        let valueContainsPredicate = NSPredicate(format: "value CONTAINS[c] %@", value)
        let expectation = [XCTNSPredicateExpectation(predicate: valueContainsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element label value does not contain '\(value)' after \(timeoutValue) seconds or does not exist")
    }
    
    /// Wait for element to fulfill any provided predicate condition as string
    static func waitForElementPredicate(_ element: XCUIElement, _ timeoutValue: Double, _ predicate: NSPredicate) {
        let expectation = [XCTNSPredicateExpectation(predicate: predicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element did not fulfil `\(predicate)` condition after \(timeoutValue) seconds")
    }
}
