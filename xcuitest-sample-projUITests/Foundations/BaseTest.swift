//
//  BaseTest.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

class BaseTest: XCTestCase {
    private let app = XCUIApplication()

    private let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    private let device = XCUIDevice.shared
    
    override func setUp() {
        guard let testName = cleanedTestName else {
            XCTFail("Could not clean current test name")
            return
        }
        
        if testName.contains("Permissions") {
            app.terminate()
            deleteApp()
        }
        
        // Fail-fast tests
        continueAfterFailure = false
        // Start the AUT
        app.launch()
    }
    
    override func tearDown() {
        let screenshot = XCUIScreen.main.screenshot()
        let screenshotAttachment = XCTAttachment(screenshot: screenshot)
        screenshotAttachment.lifetime = .deleteOnSuccess
        add(screenshotAttachment)
        app.terminate()
    }
    
    func getApp() -> XCUIApplication {
        return self.app
    }
    
    func getSpringboardApp() -> XCUIApplication {
        return self.springboard
    }
    
    func getExternalApp(bundleIdentifier: String) -> XCUIApplication {
        return XCUIApplication(bundleIdentifier: bundleIdentifier)
    }
    
    func printPageSource() {
        print(app.debugDescription)
    }
    
    ///===========================
    
    func handleCameraAlert(allow: Bool) {
        // Add UI interruption monitor to handle system alerts
        addUIInterruptionMonitor(withDescription: "System Alert") { (alert) -> Bool in
            // Check if the alert is the one you want to handle (e.g., camera permission alert)
            if alert.label.contains("Camera") {
                if allow {
                    if alert.buttons["OK"].exists {
                        alert.buttons["OK"].tap()
                    }
                } else {
                    if alert.buttons["Don’t Allow"].exists {
                        alert.buttons["Don’t Allow"].tap()
                    }
                }
            }
            return true
        }
    }
    
    func pressHomeButton() {
        device.press(.home)
    }
    
    /// This function allows to delete the app between tests
    func deleteApp() {
        app.terminate()
        pressHomeButton()
        
        let settingsIcon = springboard.icons["Settings"]
        
        if ElementsHelper.waitForElement(settingsIcon, 2) {
            // Sleep for half a second after finding the settings button because sometimes it swipes before finishing transition to initial springboard screen
            usleep(500_000) // 0.5 seconds
            springboard.swipeLeft()
        }
       
        let appName = "SampleApp"
        let icon = springboard.icons[appName]
        let iconExists = ElementsHelper.waitForElement(icon, TestConstants.Timeout.short)
        
        guard iconExists else { return }

        icon.press(forDuration: TestConstants.Timeout.short)
        
        let editHomeScreenAlert = springboard.alerts["Edit Home Screens"]
        if ElementsHelper.waitForElement(editHomeScreenAlert, 1) {
            let editHomeScreenAlertButton = editHomeScreenAlert.buttons["OK"]
            editHomeScreenAlertButton.tap()
        }

        let deleteAppButton = springboard.icons[appName].buttons["DeleteButton"]
        deleteAppButton.tap()
        
        let additional_confirmation = springboard.alerts["Remove “\(appName)”?"].buttons["Delete App"]
        additional_confirmation.tap()
        
        let deleteConfirmation = springboard.alerts["Delete “\(appName)”?"].buttons["Delete"]
        deleteConfirmation.tap()
        pressHomeButton()
    }
    
    private var cleanedTestName: String? {
        let testName = self.name
        do {
            let regex = try NSRegularExpression(pattern: "(?<= )(.*?)(?=])")
            guard let match = regex.firstMatch(in: testName, range: NSRange(testName.startIndex..., in: testName)),
                let range = Range(match.range(at: 1), in: testName) else { return nil }
            return String(testName[range])
        } catch let error as NSError {
            print("[UITest] invalid regex: \(error.localizedDescription)")
            return nil
        }
    }
}
