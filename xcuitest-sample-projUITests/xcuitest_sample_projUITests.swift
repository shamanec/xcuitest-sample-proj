//
//  xcuitest_sample_projUITests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

final class xcuitest_sample_projUITests: Base {
    
    func testOMG() {
        print(app.debugDescription)
        InteractionHelper.performGentleSwipeUntil(app.scrollViews["DummyPage1Tab"], .left, 5, until: app.staticTexts["carousel_item10"].exists)
    }
    
//    func testOMG2() {
//        InteractionHelper.performSwipeUntil(app.scrollViews["DummyPage1Tab"], .left, 3, until: app.staticTexts["carousel_item10"].exists)
//    }
}
