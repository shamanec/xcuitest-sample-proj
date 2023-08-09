//
//  Alerts.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 2.08.23.
//

import XCTest

class Alerts {
    private static let app = BaseTest().getApp()
    private static let springboard = BaseTest().getSpringboardApp()
    
    // MARK: - App alerts handling
    /// Agnostically handle application alert -  wait for alert and tap the first button on it
    static func handleAppAlert() {
        handleAppAlert("")
    }
    
    /// Handle application alert targetting specific button
    static func handleAppAlert(_ button: String) {
        let alert = app.alerts.firstMatch
        handleAppAlert(alert, button)
    }
    
    /// Handle application alert by text displayed in title or description and also specific button label
    static func handleAppAlert(_ text: String, _ button: String) {
        let alert = app.alerts.firstMatch
        if alert.staticTexts.element(withLabelContaining: text).exists {
            handleAppAlert(alert, button)
            return
        }
        XCTFail("There was no alert found that contains text: \(text)")
    }
    
    /// Handle application alert by element and targetting specific button
    static func handleAppAlert(_ alert: XCUIElement, _ button: String) {
        XCTAssertTrue(Elements.waitForElement(alert, TestConstants.Timeout.medium), "Alert element was not found")
        var alertButton: XCUIElement
        if button == "" {
            alertButton = alert.buttons.firstMatch
            XCTAssertTrue(alertButton.exists, "No button was found in the presented alert")
        } else {
            alertButton = alert.buttons[button]
            XCTAssertTrue(alertButton.exists, "No button with identifier: `\(button)` was found in the presented alert")
        }
        alertButton.tap()
        Elements.waitForElementExistence(alert, TestConstants.Timeout.veryShort, false)
    }
    
    // MARK: - System alerts handling
    /// Agnostically handle system alert -  wait for alert and tap the first button on it
    static func handleSystemAlert() {
        handleSystemAlert("")
    }
    
    /// Handle system alert targetting specific button
    static func handleSystemAlert(_ button: String) {
        let alert = springboard.alerts.firstMatch
        handleSystemAlert(alert, button)
    }
    
    /// Handle system alert by text displayed in title or description and also specific button label
    static func handleSystemAlert(_ text: String, _ button: String) {
        let alerts = springboard.alerts
        for i in 0...alerts.count {
            let currentAlert = alerts.element(boundBy: i)
            if currentAlert.staticTexts.element(withLabelContaining: text).exists {
                handleSystemAlert(currentAlert, button)
                return
            }
        }
        XCTFail("There was no alert found that contains text: \(text)")
    }
    
    /// Handle system alert by element and targetting specific button
    static func handleSystemAlert(_ alert: XCUIElement, _ button: String) {
        Elements.waitForElementExistence(alert, TestConstants.Timeout.short, true)
        var alertButton: XCUIElement
        if button == "" {
            alertButton = alert.buttons.firstMatch
            XCTAssertTrue(alertButton.exists, "No button was found in the presented alert")
        } else {
            alertButton = alert.buttons[button]
            XCTAssertTrue(alertButton.exists, "No button with identifier: `\(button)` was found in the presented alert")
        }
        alertButton.tap()
        Elements.waitForElementExistence(alertButton, TestConstants.Timeout.veryShort, false)
    }
}
