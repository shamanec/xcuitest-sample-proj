//
//  FirstPage.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

class FirstPage: BasePage {
    
    var carousel: XCUIElement { app.scrollViews.matching(identifier: "carousel-view").firstMatch }
    var carouselItems: XCUIElementQuery { carousel.staticTexts }
    var disappearingButton: XCUIElement { app.buttons["disappearing-button"] }
    var textField: XCUIElement { app.textFields["text-field"] }
    var argumentText: XCUIElement { app.staticTexts["argument-text"] }
    var slider: XCUIElement { app.sliders["slider"] }
    var picker: XCUIElement { app.pickers["picker"] }
    var pickerWheel: XCUIElement { picker.pickerWheels.firstMatch }
    var triggerAlertButton: XCUIElement { app.buttons["alert-button"] }
}
