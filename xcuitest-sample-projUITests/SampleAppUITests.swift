//
//  xcuitest_sample_projUITests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

final class SampleAppUITests: BaseTest {
    let firstScreen = FirstScreen()
    let secondScreen = SecondScreen()
    let tabBar = TabBar()
    let thirdScreen = ThirdScreen()
    
    func testGentleSwipeUntil() {
        Interaction.performGentleSwipeUntil(firstScreen.carousel, .left, 5, until: firstScreen.carouselItems.element(matching: NSPredicate(format: "label CONTAINS[c] 'Item 10'")).exists)
    }
    
    func testGenericSwipeUntil() {
        Interaction.performSwipeUntil(firstScreen.carousel, .left, 3, until: firstScreen.carouselItems["Item 10"].exists)
    }
    
    func testElementToElementPositionPass() {
        // This should pass
        Element.validateElementToElementPosition(firstScreen.carouselItems["Item 2"], firstScreen.carouselItems["Item 3"], .leftOf)
    }
    
    func testElementToElementPositionFail() {
        // This should fail
        Element.validateElementToElementPosition(firstScreen.carouselItems["Item 2"], firstScreen.carouselItems["Item 3"], .rightOf)
    }
    
    func testGetLastMatchFromQuery() {
        let text = firstScreen.carouselItems.lastMatch.label
        print("The label of the last matching element in the carousel is `\(text)`")
        XCTAssertFalse(text == "Item 1")
    }
    
    func testElementDisappearsSameScreen() {
        XCTAssertTrue(firstScreen.disappearingButton.isVisible)
        firstScreen.disappearingButton.tap()
        Element.waitForElementExistence(firstScreen.disappearingButton, 6, false)
        XCTAssertFalse(firstScreen.disappearingButton.isVisible)
    }
    
    func testElementDisappearsSameScreen2() {
        XCTAssertTrue(firstScreen.disappearingButton.isVisible)
        firstScreen.disappearingButton.tap()
        Element.waitForElementExistenceAlt(firstScreen.disappearingButton, 6, false)
        XCTAssertFalse(firstScreen.disappearingButton.isVisible)
    }
    
    func testElementNotExistChangeScreens() {
        XCTAssertTrue(firstScreen.disappearingButton.isVisible)
        tabBar.openSecondPage()
        XCTAssertFalse(firstScreen.disappearingButton.exists)
    }
    
    func testWaitForQueryHaveNumberOfElements() {
        tabBar.openSecondPage()
        let elements = secondScreen.loadingElements
        // Wait for 10 seconds to have 5 elements, should pass
        Element.waitUntilTableFilled(elements, 5, TestConstants.Timeout.medium)
        // Should fail because only 5 in total will be loaded
        Element.waitUntilTableFilled(elements, 6, TestConstants.Timeout.short)
    }
    
    func testTypeText() {
        let textToType = "typed-text"
        firstScreen.textField.tap()
        firstScreen.textField.typeText(textToType)
        let typedText = firstScreen.textField.textFromValue
        XCTAssertEqual(textToType, typedText)
    }
    
    func testAllowCameraPermissionsWithInterruptionMonitor() {
        // Set up UIInterruptionMonitor
        handleAlert(button: "OK")
        tabBar.openThirdPage()
        // Tap the text element, couldn't properly build triggering permissions with navigation ;D
        thirdScreen.permissionState.tap()
        // Tap the zero coordinates of the app to trigger the interruption monitor on the alert that appeared
        getApp().tapZero()
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        XCTAssertEqual(thirdScreen.getPermissionState(), "Allowed")
    }
    
    func testDenyCameraPermissionsWithInteruptionMonitor() {
        // Set up UIInterruptionMonitor
        handleCameraAlert(allow: false)
        tabBar.openThirdPage()
        // Tap the text element, couldn't properly build triggering permissions with navigation ;D
        thirdScreen.permissionState.tap()
        // Tap the zero coordinates of the app to trigger the interruption monitor on the alert that appeared
        getApp().tapZero()
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        XCTAssertEqual(thirdScreen.getPermissionState(), "Denied")
    }
    
    func testAllowCameraPermissionsWithCustomAlertHandling() {
        tabBar.openThirdPage()
        // Tap the text element, couldn't properly build triggering permissions with navigation ;D
        thirdScreen.permissionState.tap()
        Alert.handleSystemAlert("OK")
        XCTAssertTrue(getSpringboardApp().alerts.count == 0)
        XCTAssertEqual(thirdScreen.getPermissionState(), "Allowed")
    }
    
    func testLaunchArgumentNotProvided() {
        XCTAssertEqual(firstScreen.argumentText.label, "Argument:Default")
    }
    
    func testSelectPickerWheelValue() {
        XCTAssertEqual(firstScreen.pickerWheel.textFromValue, "None")
        Element.setPickerValue(firstScreen.pickerWheel, "Many")
        XCTAssertEqual(firstScreen.pickerWheel.textFromValue, "Many")
    }
    
    func testSetSliderPosition() {
        Element.setSlider(firstScreen.slider, 0.8)
        print(firstScreen.slider.textFromValue)
    }
    
    func testCloseAppAlertWithAlertAndButtonName() {
        firstScreen.triggerAlertButton.tap()
        Alert.handleAppAlert(getApp().alerts.firstMatch, "Close")
    }
    
    func testCloseAppAlertWithButtonName() {
        firstScreen.triggerAlertButton.tap()
        Alert.handleAppAlert("Close")
        firstScreen.triggerAlertButton.tap()
        Alert.handleAppAlert("Accept")
    }
    
    func testCloseAppAlertAgnostic() {
        firstScreen.triggerAlertButton.tap()
        Alert.handleAppAlert("")
    }
    
    func testElementFullyVisible() {
        print(firstScreen.triggerAlertButton.isFullyVisible())
        getApp().swipeUp()
        print(firstScreen.triggerAlertButton.isFullyVisible())
    }
    
    func testAppActions() {
        App.background()
        sleep(1)
        App.foreground()
        sleep(1)
        App.terminate()
        sleep(1)
        App.restart()
        sleep(1)
        App.deleteAndRestart()
    }
    
    func testWaitForElementBySuppliedPredicate()  {
        // Passes
        Element.waitForElementPredicate(firstScreen.carousel, 2, NSPredicate(format: "exists == true"))
        // Fails
        Element.waitForElementPredicate(firstScreen.carousel, 2, NSPredicate(format: "exists == false"))
    }
    
    func testQueriesExamples() {
        tabBar.openFourthPage()
        printPageSource()
        // Simple element locator for accessibilityIdentifier or label
        // From parent XCUIElement get the first matching element of XCUIElement.ElementType
        let firstStack = getApp().otherElements["FirstStack"]
        XCTAssert(firstStack.exists)
        let secondStack = getApp().otherElements["SecondStack"]
        XCTAssert(secondStack.exists)
        let firstStackChildStack = firstStack.otherElements["FirstStackFirstChildStack"]
        XCTAssert(firstStackChildStack.exists)
        
        // Get first matching child/descendant element of XCUIElement.ElementType from parent XCUIElement
        // `firstStack.buttons` returns XCUIElementQuery from which we get `firstMatch`
        let firstStackFirstText = firstStack.staticTexts.firstMatch
        XCTAssert(firstStackFirstText.exists)
        XCTAssertEqual(firstStackFirstText.label, "FirstStackText")
        
        // Get last matching child/descendant element of XCUIElement.ElementType from parent XCUIElement
        // `firstStack.buttons` returns XCUIElementQuery from which we get `lastMatch`
        let firstStackLastText = firstStack.staticTexts.lastMatch
        XCTAssert(firstStackLastText.exists)
        XCTAssertEqual(firstStackLastText.label, "FirstStackText6")
        
        // Get all elements matching a specific identifier, returns XCUIElementQuery
        let firstStackTexts = firstStack.staticTexts.matching(identifier: "FirstStackText")
        XCTAssertTrue(firstStackTexts.count == 6)
        
        // Get specific element from XCUIElementQuery by index
        // In the example get the second XCUIElement from the XCUIElementQuery
        let firstStackSecondText = firstStackTexts.element(boundBy: 1)
        XCTAssertEqual(firstStackSecondText.label, "FirstStackText1")
        firstStackSecondText.tap()
        XCTAssertEqual(firstStackSecondText.label, "Tapped")
        
        // Get direct children of parent element based on their XCUIElement.ElementType
        // In the example get all static texts direct children of `firstStack`
        let firstStackDirectChildTexts = firstStack.children(matching: .staticText)
        XCTAssertEqual(firstStackDirectChildTexts.count, 2)
        
        // Get all descendants of parent element based on their XCUIElement.ElementType
        // In the example get all descendant static texts of `firstStack`
        let firstStackDescendantTexts = firstStack.descendants(matching: .staticText)
        XCTAssertEqual(firstStackDescendantTexts.count, 6)
        
        // Locate direct child of parent element based on its XCUIElement.ElementType and accessibilityIdentifier
        let secondStackDescendantButtonById = secondStack.descendants(matching: .button)["SecondStackButton"]
        XCTAssertTrue(secondStackDescendantButtonById.exists)
        
        // Filter elements from XCUIElementQuery based on their descendants of XCUIElement.ElementType and specific accessibilityIdentifier
        let secondStackButtonsByDescendantTypeAndId = secondStack.buttons.containing(.image, identifier: "TestImage")
        XCTAssertTrue(secondStackButtonsByDescendantTypeAndId.count > 0)
        secondStackButtonsByDescendantTypeAndId.firstMatch.tap()
        XCTAssertFalse(secondStackButtonsByDescendantTypeAndId.firstMatch.exists)
    }
}
