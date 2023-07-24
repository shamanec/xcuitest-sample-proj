//
//  BasePage.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

class BasePage {
    var app: XCUIApplication
    private static var isReflectionIdleEnabled = false
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    func waitForPageLoading(element: XCUIElement) {
        XCTAssertTrue(element.waitForExistence(timeout: TestConstants.Timeout.medium))
    }
    
    // Function to turn on/off the hack that disables waitForQuiescenceIncludingAnimationsIdle - the method that forces the test to wait until the app is idle - by replacing it with the [replace()](x-source-tag://replace) method
    /// - Parameter state: Bool parameter to activate/deactivate the app idle wait logic
    private func setReflectionIdleHack(_ state: Bool) {
        let selector = Selector(("waitForQuiescenceIncludingAnimationsIdle:"))
        guard let clazz = objc_getClass("XCUIApplicationProcess") as? AnyClass,
              let current = class_getInstanceMethod(clazz, selector),
              let replaced = class_getInstanceMethod(type(of: self), #selector(self.replace)) else {
            print("[UITest] failed to set up idle-wait reflection hack")
            return
        }
        
        if state != BasePage.isReflectionIdleEnabled {
            method_exchangeImplementations(current, replaced)
            print("[UITest] reflection idle hack " + (state ? "set" : "unset"))
            BasePage.isReflectionIdleEnabled = state
        }
    }
    
    /// - Tag: replace
    @objc func replace() {
        print("[UITest] calling reflection idle replaced method")
        return
    }
    
    // Disable idle wait logic until code inside is executed and then reenable it
    func executeUnderReflectionIdleHack(_ block: () -> Void) {
        self.setReflectionIdleHack(true)
        block()
        self.setReflectionIdleHack(false)
    }
}
