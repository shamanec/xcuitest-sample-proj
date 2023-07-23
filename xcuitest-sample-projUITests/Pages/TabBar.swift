//
//  TabBar.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

class TabBar: BasePage {
    private var defaultTabBar: XCUIElement { app }
    private var firstPageButton: XCUIElement { defaultTabBar.buttons["Carousel"] }
    private var secondPageButton: XCUIElement { defaultTabBar.buttons["Loading"] }
    
    func openFirstPage() {
        firstPageButton.tap()
    }
    
    func openSecondPage() {
        secondPageButton.tap()
    }
}
