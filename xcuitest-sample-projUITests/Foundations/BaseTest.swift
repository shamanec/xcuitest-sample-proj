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
        // Fail-fast tests
        continueAfterFailure = false
        
        // Reset camera permissions
        app.resetAuthorizationStatus(for: .camera)
        
        guard let testName = cleanedTestName else {
            XCTFail("Could not clean current test name")
            return
        }
        
        // This can be used to delete the app for specific tests in case that is needed for the particular test scenario
//        if testName.contains("Permissions") {
//            app.terminate()
//            deleteApp()
//        }
        
        // Start the AUT
        app.launchArguments = launchArguments()
        app.launch()
    }
    
    override func tearDown() {
        let screenshot = XCUIScreen.main.screenshot()
        let screenshotAttachment = XCTAttachment(screenshot: screenshot)
        screenshotAttachment.lifetime = .deleteOnSuccess
        add(screenshotAttachment)
        app.terminate()
    }
    
    func launchArguments() -> [String] {
        // Override this method in subclasses to provide custom launch arguments
        return []
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
    
    // When an alert or other modal UI is an expected part of the test workflow, don't write a UI interruption monitor.
    // The test won’t use the monitor because the modal UI isn’t blocking the test.
    // A UI test only tries its UI interruption monitors if the elements it needs to interact with to complete the test are blocked by an interruption from an unrelated UI.
    // https://developer.apple.com/documentation/xctest/xctestcase/handling_ui_interruptions
    /// Accept or deny camera permissions
    func handleCameraAlert(allow: Bool) {
        // Add UI interruption monitor to handle system alerts
        addUIInterruptionMonitor(withDescription: "System Alert") { alert -> Bool in
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
    
    // When an alert or other modal UI is an expected part of the test workflow, don't write a UI interruption monitor.
    // The test won’t use the monitor because the modal UI isn’t blocking the test.
    // A UI test only tries its UI interruption monitors if the elements it needs to interact with to complete the test are blocked by an interruption from an unrelated UI.
    // https://developer.apple.com/documentation/xctest/xctestcase/handling_ui_interruptions
    func handleAlert(title: String, button: String) {
        addUIInterruptionMonitor(withDescription: "Alert") { alert -> Bool in
            var targetButton: XCUIElement
            if !title.isEmpty && alert.label.contains(title) {
                targetButton = alert.buttons[button]
            } else {
                targetButton = alert.buttons[button]
            }
            if targetButton.exists {
                targetButton.tap()
            }
            return true
        }
    }
    
    func handleAlert(button: String) {
        handleAlert(title: "", button: button)
    }
    
    func pressHomeButton() {
        device.press(.home)
    }
    
    func terminateApp() {
        app.terminate()
        XCTAssert(app.wait(for: .notRunning, timeout: 2), "App was not successfully terminated")
    }
    
    /// This function allows to delete the app between tests - to trigger permission alerts again for example
    func deleteApp() {
        let appName = "SampleApp"
        Logger.log("Deleting application '\(appName)'")
        let appIcon = springboard.icons[appName]
        
        // Attempt killing the app just in case
        terminateApp()
        // Go to the initial springboard screen
        pressHomeButton()
        
        // Wait for the Settings app icon to appear before swiping to search for the AUT
        let settingsIcon = springboard.icons["Settings"]
        if Elements.waitForElement(settingsIcon, 2) {
            // Sleep for half a second after finding the settings button because sometimes it swipes before finishing transition to initial springboard screen
            usleep(500_000) // 0.5 seconds
            Interactions.performSwipeUntil(springboard, .left, 2, until: appIcon.exists && appIcon.isHittable)
        }
        appIcon.press(forDuration: TestConstants.Timeout.veryShort)
        
        let editHomeScreenAlert = springboard.alerts["Edit Home Screens"]
        if Elements.waitForElement(editHomeScreenAlert, 1) {
            Alerts.handleSystemAlert(editHomeScreenAlert, "OK")
        }
        
        let deleteAppButton = springboard.icons[appName].buttons["DeleteButton"]
        if Elements.waitForElement(deleteAppButton, 5) {
            deleteAppButton.tap()
        } else {
            XCTFail("Delete application button did not appear in 5 seconds")
        }
        
        Alerts.handleSystemAlert("Remove “\(appName)”?", "Delete App")
        Alerts.handleSystemAlert("Delete “\(appName)”?", "Delete")
        pressHomeButton()
    }
    
    ///
    private var cleanedTestName: String? {
        let testName = self.name
        do {
            // The pattern (?<= )(.*?)(?=]) is a positive lookbehind (?<= ), followed by a non-greedy capture group (.*?), and finally, a positive lookahead (?=]).
            // This regular expression is designed to match the text between a space and a closing square bracket ("]")
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
