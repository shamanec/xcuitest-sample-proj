//
//  SecondPage.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

class SecondPage: BasePage {
    var loadingElements: XCUIElementQuery { app.staticTexts.matching(identifier: "loaded-el") }
}
