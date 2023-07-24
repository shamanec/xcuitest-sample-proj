//
//  XCUIElementQuery+Extensions.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

extension XCUIElementQuery {
    /// Get the last element from the query
    var lastMatch: XCUIElement { return self.element(boundBy: self.count - 1) }
    
    /// Check if the XCUIElementQuery has no elements
    var isEmpty: Bool { count == 0 }
    
    // MARK: - Return element by predicate methods
    /// Get element where the label exactly matches the provided string
    func element(withLabelMatching text: String) -> XCUIElement {
        return element(matching: NSPredicate(format: "label == %@", text))
    }

    /// Get element where the label contains the provided string
    func element(withLabelContaining text: String) -> XCUIElement {
        return element(matching: NSPredicate(format: "label CONTAINS %@", text))
    }

    /// Get element where the label ends with the provided string
    func element(withLabelSuffixed text: String) -> XCUIElement {
        return element(matching: NSPredicate(format: "label ENDSWITH %@", text))
    }
    
    /// Get element where the label begins with the provided string
    func element(withLabelPrefixed text: String) -> XCUIElement {
        return element(matching: NSPredicate(format: "label BEGINSWITH %@", text))
    }
    
    /// Get element where the label 
    func element(withLabelLike text: String) -> XCUIElement {
        return element(matching: NSPredicate(format: "label LIKE %@", text))
    }
    
}
