//
//  ThirdPage.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 23.07.23.
//

import XCTest

class ThirdScreen: BaseScreen {
    var permissionState: XCUIElement { app.staticTexts["permission-state"] }
    
    func getPermissionState() -> String {
        return permissionState.label
    }
}
