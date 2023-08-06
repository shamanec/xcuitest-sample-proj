//
//  App.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 3.08.23.
//

import XCTest

class App {
    private static let app = BaseTest().getApp()
    private static let springboard = BaseTest().getSpringboardApp()
    
    /// Put the AUT in the background
    static func background() {
        Logger.log("Putting application in the background")
        Interactions.pressHomeButton()
        // This assert did not work, probably I haven't coded the sample app properly
        // But it should work
        //XCTAssert(app.wait(for: .runningBackground, timeout: TestConstants.Timeout.medium), "App was not put in the background")
    }
    
    /// Put the AUT in the foreground
    static func foreground() {
        Logger.log("Putting application to the foreground")
        app.activate()
        XCTAssert(app.wait(for: .runningForeground, timeout: TestConstants.Timeout.short), "App was not put in foreground")
    }
    
    /// Terminate the AUT
    static func terminate() {
        Logger.log("Terminating application")
        app.terminate()
        XCTAssert(app.wait(for: .notRunning, timeout: TestConstants.Timeout.short), "App was not successfully terminated")
    }
    
    /// Launch the AUT
    static func launch() {
        Logger.log("Launching application")
        app.launch()
        XCTAssert(app.wait(for: .runningForeground, timeout: TestConstants.Timeout.short), "App was not launched")
    }
    
    /// Restart the AUT
    static func restart() {
        Logger.log("Restarting application")
        terminate()
        launch()
    }
    
    /// Delete and restart the AUT
    static func deleteAndRestart() {
        Logger.log("Deleting and relaunching application")
        delete()
        launch()
    }
    
    static func delete(_ appName: String = "SampleApp") {
        Logger.log("Deleting application '\(appName)'")
        let appIcon = springboard.icons[appName]
        
        // Attempt killing the app just in case
        terminate()
        // Go to the initial springboard screen
        Interactions.pressHomeButton()
        
        // Wait for the Settings app icon to appear before swiping to search for the AUT
        let settingsIcon = springboard.icons["Settings"]
        if Elements.waitForElement(settingsIcon, 2) {
            // Sleep for half a second after finding the settings button because sometimes it swipes before finishing transition to initial springboard screen
            usleep(500_000) // 0.5 seconds
            Interactions.performSwipeUntil(springboard, .left, 2, until: appIcon.exists && appIcon.isHittable)
        }
        appIcon.press(forDuration: TestConstants.Timeout.veryShort)
        
        let editHomeScreenAlert = springboard.alerts["Edit Home Screens"]
        if Elements.waitForElement(editHomeScreenAlert, TestConstants.Timeout.second) {
            Alerts.handleSystemAlert(editHomeScreenAlert, "OK")
        }
        
        let deleteAppButton = springboard.icons[appName].buttons["DeleteButton"]
        if Elements.waitForElement(deleteAppButton, TestConstants.Timeout.short) {
            deleteAppButton.tap()
        } else {
            XCTFail("Delete application button did not appear in 5 seconds")
        }
        
        Alerts.handleSystemAlert("Remove “\(appName)”?", "Delete App")
        Alerts.handleSystemAlert("Delete “\(appName)”?", "Delete")
        Interactions.pressHomeButton()
    }
}
