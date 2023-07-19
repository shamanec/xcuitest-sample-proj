//
//  HomePage.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 19.07.23.
//

import XCTest

class HomePage: Base {
    private var cells: XCUIElementQuery { app.cells }
    private var staticTexts: XCUIElementQuery { app.staticTexts }
    
    func openDeveloperOptions() {
        cells.element(withLabelMatching: "Developer").tap()
    }
}
