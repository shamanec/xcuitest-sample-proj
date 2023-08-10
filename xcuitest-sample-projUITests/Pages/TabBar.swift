//
//  TabBar.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

class TabBar: BaseScreen {
    private var defaultTabBar: XCUIElement { app }
    private var firstPageButton: XCUIElement { defaultTabBar.buttons["Carousel"] }
    private var secondPageButton: XCUIElement { defaultTabBar.buttons["Loading"] }
    private var thirdPageButton: XCUIElement { defaultTabBar.buttons["Permissions"] }
    private var fourthPageButton: XCUIElement { defaultTabBar.buttons["Queries"] }
    
    func openFirstPage() {
        firstPageButton.tap()
    }
    
    func openSecondPage() {
        secondPageButton.tap()
    }
    
    func openThirdPage() {
        thirdPageButton.tap()
    }
    
    func openFourthPage() {
        fourthPageButton.tap()
    }
}
