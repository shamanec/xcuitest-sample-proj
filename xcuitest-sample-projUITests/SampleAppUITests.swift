//
//  xcuitest_sample_projUITests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

final class SampleAppUITests: BaseTest {
    func testGentleSwipeUntil() {
        let firstPage = FirstPage(app: getApp())
        Interactions.performGentleSwipeUntil(firstPage.carousel, .left, 5, until: firstPage.carouselItems.element(matching: NSPredicate(format: "label CONTAINS[c] 'Item 10'")).exists)
    }
    
    func testGenericSwipeUntil() {
        let firstPage = FirstPage(app: getApp())
        Interactions.performSwipeUntil(firstPage.carousel, .left, 3, until: firstPage.carouselItems["Item 10"].exists)
    }
    
    func testElementToElementPositionPass() {
        let firstPage = FirstPage(app: getApp())
        // This should pass
        Elements.validateElementToElementPosition(firstPage.carouselItems["Item 2"], firstPage.carouselItems["Item 3"], .leftOf)
    }
    
    func testElementToElementPositionFail() {
        let firstPage = FirstPage(app: getApp())
        // This should fail
        Elements.validateElementToElementPosition(firstPage.carouselItems["Item 2"], firstPage.carouselItems["Item 3"], .rightOf)
    }
    
    func testGetLastMatchFromQuery() {
        let firstPage = FirstPage(app: getApp())
        let text = firstPage.carouselItems.lastMatch.label
        print("The label of the last matching element in the carousel is `\(text)`")
        XCTAssertFalse(text == "Item 1")
    }
    
    func testElementDisappearsSameScreen() {
        let firstPage = FirstPage(app: getApp())
        XCTAssertTrue(firstPage.disappearingButton.isVisible)
        firstPage.disappearingButton.tap()
        Elements.waitUntilElementDisappears(firstPage.disappearingButton, 6)
        XCTAssertFalse(firstPage.disappearingButton.isVisible)
    }
    
    func testElementNotExistChangeScreens() {
        let firstPage = FirstPage(app: getApp())
        XCTAssertTrue(firstPage.disappearingButton.isVisible)
        let navigation = TabBar(app: getApp())
        navigation.openSecondPage()
        XCTAssertFalse(firstPage.disappearingButton.exists)
    }
    
    func testWaitForQueryHaveNumberOfElements() {
        let navigation = TabBar(app: getApp())
        navigation.openSecondPage()
        let secondPage = SecondPage(app: getApp())
        let elements = secondPage.loadingElements
        // Wait for 10 seconds to have 5 elements, should pass
        Elements.waitUntilTableFilled(elements, 5, TestConstants.Timeout.medium)
        // Should fail because only 5 in total will be loaded
        Elements.waitUntilTableFilled(elements, 6, TestConstants.Timeout.short)
    }
    
    func testTypeText() {
        let firstPage = FirstPage(app: getApp())
        let textToType = "typed-text"
        firstPage.textField.tap()
        firstPage.textField.typeText(textToType)
        let typedText = firstPage.textField.textFromValue
        XCTAssertEqual(textToType, typedText)
    }
    
    func testAllowCameraPermissions() {
        handleCameraAlert(allow: true)
        let navigation = TabBar(app: getApp())
        navigation.openThirdPage()
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        let thirdPage = ThirdPage(app: getApp())
        XCTAssertEqual(thirdPage.getPermissionState(), "Allowed")
    }
    
    func testDenyCameraPermissions() {
        handleCameraAlert(allow: false)
        let navigation = TabBar(app: getApp())
        navigation.openThirdPage()
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        let thirdPage = ThirdPage(app: getApp())
        XCTAssertEqual(thirdPage.getPermissionState(), "Denied")
    }
    
    func testLaunchArgumentNotProvided() {
        let firstPage = FirstPage(app: getApp())
        XCTAssertEqual(firstPage.argumentText.label, "Argument:Default")
    }
    
    func testSelectPickerWheelValue() {
        let firstPage = FirstPage(app: getApp())
        XCTAssertEqual(firstPage.pickerWheel.textFromValue, "None")
        Elements.setPickerValue(firstPage.pickerWheel, "Many")
        XCTAssertEqual(firstPage.pickerWheel.textFromValue, "Many")
    }
    
    func testSetSliderPosition() {
        let firstPage = FirstPage(app: getApp())
        Elements.setSlider(firstPage.slider, 0.8)
        print(firstPage.slider.textFromValue)
    }
    
    func testCloseAppAlertWithAlertAndButtonName() {
        let firstPage = FirstPage(app: getApp())
        firstPage.triggerAlertButton.tap()
        Elements.handleAppAlert(getApp().alerts.firstMatch, "Close")
    }
    
    func testCloseAppAlertWithButtonName() {
        let firstPage = FirstPage(app: getApp())
        firstPage.triggerAlertButton.tap()
        Elements.handleAppAlert("Close")
        firstPage.triggerAlertButton.tap()
        Elements.handleAppAlert("Accept")
    }
    
    func testCloseAppAlertAgnostic() {
        let firstPage = FirstPage(app: getApp())
        firstPage.triggerAlertButton.tap()
        Elements.handleAppAlert("")
    }
}
