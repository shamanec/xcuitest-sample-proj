//
//  BasePage.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 19.07.23.
//

import XCTest

class BasePage {
    let app = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    
    func navigateBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
