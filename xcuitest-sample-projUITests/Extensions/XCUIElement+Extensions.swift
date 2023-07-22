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
    
    /// Indicates if the element is currently "visible" for interaction on the screen - it does not indicate if the element is fully visible or only partially
    var isVisible: Bool {
        // When accessing properties of XCUIElement, XCTest works differently than in a case of actions on elements
        // - there is no waiting for the app to idle and to finish all animations.
        // This can lead to problems and test flakiness as the test will evaluate a query before e.g. view transition has been completed.
        return exists && isHittable
    }
}
