//
//  BaseTest.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

class BaseTest: XCTestCase {
    private let defaultLoadingTime = 30.0
    static var isReflectionIdleEnabled = false
    private let app = XCUIApplication()
    
    override func setUp() {
        // Fail-fast tests
        continueAfterFailure = false
        // Start the AUT
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    func getApp() -> XCUIApplication {
        return self.app
    }
    
    func getExternalApp(bundleIdentifier: String) -> XCUIApplication {
        return XCUIApplication(bundleIdentifier: bundleIdentifier)
    }
    
    func printPageSource() {
        print(app.debugDescription)
    }
    
    public func waitForPageLoading(element: XCUIElement) {
        XCTAssertTrue(element.waitForExistence(timeout: defaultLoadingTime))
    }
    
    // Function to turn on/off the hack that disables waitForQuiescenceIncludingAnimationsIdle - the method that forces the test to wait until the app is idle - by replacing it with the [replace()](x-source-tag://replace) method
    /// - Parameter state: Bool parameter to activate/deactivate the app idle wait logic
    func setReflectionIdleHack(_ state: Bool) {
        let selector = Selector(("waitForQuiescenceIncludingAnimationsIdle:"))
        guard let clazz = objc_getClass("XCUIApplicationProcess") as? AnyClass,
              let current = class_getInstanceMethod(clazz, selector),
              let replaced = class_getInstanceMethod(type(of: self), #selector(self.replace)) else {
            print("[UITest] failed to set up idle-wait reflection hack")
            return
        }
        
        if state != BaseTest.isReflectionIdleEnabled {
            method_exchangeImplementations(current, replaced)
            print("[UITest] reflection idle hack " + (state ? "set" : "unset"))
            BaseTest.isReflectionIdleEnabled = state
        }
    }
    
    /// - Tag: replace
    @objc func replace() {
        print("[UITest] calling reflection idle replaced method")
        return
    }
    
    // Disable idle wait logic until code inside is executed and then reenable it
    private func executeUnderReflectionIdleHack(_ block: () -> Void) {
        self.setReflectionIdleHack(true)
        block()
        self.setReflectionIdleHack(false)
    }
}
