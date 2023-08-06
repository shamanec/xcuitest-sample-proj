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
