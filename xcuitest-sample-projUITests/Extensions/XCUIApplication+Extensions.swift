//
//  XCUIApplication+Extensions.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

extension XCUIApplication {
    
    /// Tap the zero coordinate of the app, useful for closing keyboards or triggering UIApplicationMonitor
    func tapZero() { coordinate(withNormalizedOffset: .zero).tap() }
}
