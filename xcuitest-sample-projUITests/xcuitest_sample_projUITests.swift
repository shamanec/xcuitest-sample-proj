//
//  xcuitest_sample_projUITests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

final class xcuitest_sample_projUITests: BaseTest {
    let firstPage = FirstPage()
    let secondPage = SecondPage()
    let thirdPage = ThirdPage()
    let navigation = TabBar()
    
    func testGentleSwipeUntil() {
        printPageSource()
        InteractionHelper.performGentleSwipeUntil(firstPage.carousel, .left, 5, until: firstPage.carouselItems.element(matching: NSPredicate(format: "label CONTAINS[c] 'Item 10'")).exists)
    }
    
    func testGenericSwipeUntil() {
        InteractionHelper.performSwipeUntil(firstPage.carousel, .left, 3, until: firstPage.carouselItems["Item 10"].exists)
    }
    
    func testElementToElementPositionPass() {
        // This should pass
        ElementsHelper.validateElementToElementPosition(firstPage.carouselItems["Item 2"], firstPage.carouselItems["Item 3"], .leftOf)
    }
    
    func testElementToElementPositionFail() {
        // This should fail
        ElementsHelper.validateElementToElementPosition(firstPage.carouselItems["Item 2"], firstPage.carouselItems["Item 3"], .rightOf)
    }
    
    func testGetLastMatchFromQuery() {
        let text = firstPage.carouselItems.lastMatch.label
        print("The label of the last matching element in the carousel is `\(text)`")
    }
    
    func testElementDisappearsSameScreen() {
        XCTAssertTrue(firstPage.disappearingButton.isVisible)
        firstPage.disappearingButton.tap()
        ElementsHelper.waitUntilElementDisappears(firstPage.disappearingButton, 6)
        XCTAssertFalse(firstPage.disappearingButton.isVisible)
    }
    
    func testElementNotExistChangeScreens() {
        XCTAssertTrue(firstPage.disappearingButton.isVisible)
        navigation.openSecondPage()
        XCTAssertFalse(firstPage.disappearingButton.exists)
    }
    
    func testWaitForQueryHaveNumberOfElements() {
        navigation.openSecondPage()
        let elements = secondPage.loadingElements
        // Wait for 10 seconds to have 5 elements, should pass
        ElementsHelper.waitUntilTableFilled(elements, 5, TestConstants.Timeout.medium)
        // Wait 5 more seconds to have 6 elements, should fail because only 5 in total will be loaded
        ElementsHelper.waitUntilTableFilled(elements, 6, TestConstants.Timeout.short)
    }
    
    func testTypeText() {
        let textToType = "typed-text"
        firstPage.textField.tap()
        firstPage.textField.typeText(textToType)
        let typedText = firstPage.textField.textFromValue
        XCTAssertEqual(textToType, typedText)
    }
    
    func testAllowCameraPermissions() {
        handleCameraAlert(allow: true)
        navigation.openThirdPage()
        printPageSource()
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        let state = thirdPage.getPermissionState()
        XCTAssertEqual(state, "Allowed")
    }
    
    func testDenyCameraPermissions() {
        handleCameraAlert(allow: false)
        navigation.openThirdPage()
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        let state = thirdPage.getPermissionState()
        XCTAssertEqual(state, "Denied")
    }
}
