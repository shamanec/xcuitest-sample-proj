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
    
    // MARK: - Wait functions
    
    /// Wait for element to exist
    static func waitForElement(_ element: XCUIElement, _ timeoutValue: Double) -> Bool {
        return element.waitForExistence(timeout: timeoutValue)
    }
    
    /// Wait until XCUIElement disappears
    ///
    /// - Parameters:
    ///   - element: XCUIElement that will be polled until it disappears
    ///   - timeoutValue: How long to wait for the element to disappear
    static func waitUntilElementDisappears(_ element: XCUIElement, _ timeoutValue: Double) {
        let startTime = Date().timeIntervalSince1970
        var elementVisible = true
        
        while (Date().timeIntervalSince1970 - startTime) < timeoutValue {
            if !element.exists {
                elementVisible = false
                break
            }
            usleep(300_000) // 300ms
        }
        XCTAssertFalse(elementVisible, "\(element) is still visible(exists) after \(timeoutValue) seconds")
    }
    
    /// Wait until an XCUIElementQuery has at least X number of elements
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
            usleep(300_000) // 300ms
        }
        XCTAssertTrue(result, "XCUIElementQuery was not filled with \(elementsCount) elements in \(timeoutValue) seconds")
    }
    
    func waitForElementHittableAttributeToBe(_ element: XCUIElement, _ timeoutValue: Double, _ visibility: Bool) {
        let predicate = "hittable == \(String(visibility))"
        let isDisplayedPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: isDisplayedPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element \(element) is not displayed and/or hittable")
    }
    
    func waitForElementEnabledAttributeToBe(_ element: XCUIElement, _ timeoutValue: Double, _ enabledValue: Bool) {
        let predicate = "isEnabled == \(String(enabledValue))"
        let isEnabledPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: isEnabledPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element \(element) is not enabled")
    }
    
    func waitForElementExistenceToBe(_ element: XCUIElement, _ timeoutValue: Double, _ existence: Bool) {
        let predicate = "exists == \(String(existence))"
        let existsPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: existsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element \(element) does not exist")
    }
    
    func waitForElementLabelAttributeToBe(_ element: XCUIElement, _ timeoutValue: Double, _ labelValue: String) {
        let predicate = "label == '\(String(labelValue))'"
        let labelEqualsPredicate = NSPredicate(format: predicate)
        let expectation = [XCTNSPredicateExpectation(predicate: labelEqualsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element \(element) label value should be '\(labelValue)'")
    }
    
    func waitForElementValueAttributeContains(_ element: XCUIElement, _ timeoutValue: Double, _ value: String) {
        let valueContainsPredicate = NSPredicate(format: "value CONTAINS[c] %@", value)
        let expectation = [XCTNSPredicateExpectation(predicate: valueContainsPredicate, object: element)]
        let result = XCTWaiter().wait(for: expectation, timeout: timeoutValue)
        XCTAssertEqual(result, .completed, "Element \(element) label value does not contain '\(value)'")
    }
}
