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
    
    // MARK: Return element by predicate methods
    /// Returns element with label matching provided string.
    /// - note:
    /// String matching is customizable with operators available in `NSPredicate` specification.
    /// Check the `StringComparisonOperator` for available options.
    /// ```swift
    /// let text = app.staticTexts.element(withLabelMatching: "John*", comparisonOperator: .like)
    /// XCTAssertTrue(text.exists)
    /// ```
    /// - Parameters:
    ///   - text: String to search for.
    ///   - comparisonOperator: Operation to use when performing comparison.
    /// - Returns: `XCUIElement` that label matches to given text.
    func element(
        withLabelMatching text: String,
        comparisonOperator: StringComparisonOperator = .equals
    ) -> XCUIElement {
        return element(matching: NSPredicate(format: "label \(comparisonOperator.rawValue) %@", text))
    }

    /// Returns element with label which contains provided string.
    /// ```swift
    /// let text = app.staticTexts.element(withLabelContaining: "John")
    /// XCTAssertTrue(text.exists)
    /// ```
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label contains given text.
    func element(withLabelContaining text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .contains)
    }

    /// Returns element with label which ends with provided string.
    /// ```swift
    /// let text = app.staticTexts.element(withLabelPrefixed: "John")
    /// XCTAssertTrue(text.exists)
    /// ```
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    func element(withLabelSuffixed text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .endsWith)
    }
    
    enum StringComparisonOperator: RawRepresentable {
        case equals
        case beginsWith
        case contains
        case endsWith
        case like
        case matches
        case other(comparisonOperator: String)

        var rawValue: String {
            switch self {
            case .equals: return "=="
            case .beginsWith: return "BEGINSWITH"
            case .contains: return "CONTAINS"
            case .endsWith: return "ENDSWITH"
            case .like: return "LIKE"
            case .matches: return "MATCHES"
            case .other(let comparisonOperator): return comparisonOperator
            }
        }

        init(rawValue: String) {
            switch rawValue {
            case "==": self = .equals
            case "BEGINSWITH": self = .beginsWith
            case "CONTAINS": self = .contains
            case "ENDSWITH": self = .endsWith
            case "LIKE": self = .like
            case "MATCHES": self = .matches
            default: self = .other(comparisonOperator: rawValue)
            }
        }
    }
}
