//
//  LaunchArgumentTests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 24.07.23.
//

import XCTest

class LaunchArgumentTests: BaseTest {
    override func launchArguments() -> [String] {
        return ["-showCustomText"]
    }
    
    func testLaunchArgument() {
        let firstPage = FirstPage(app: getApp())
        XCTAssertEqual(firstPage.argumentText.label, "Argument:Custom")
    }
}
