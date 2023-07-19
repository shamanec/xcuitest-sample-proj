//
//  xcuitest_sample_projUITests.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import XCTest

final class xcuitest_sample_projUITests: Base {
    
    let homePage = HomePage()

    func testGentleSwipeExample() {
        app.performGentleSwipe(.up, TestConstants.SwipeAdjustment.small)
        app.performGentleSwipe(.up, TestConstants.SwipeAdjustment.medium)
        app.performGentleSwipe(.up, TestConstants.SwipeAdjustment.normal)
        app.performGentleSwipe(.up, TestConstants.SwipeAdjustment.big)
        app.performGentleSwipe(.up, TestConstants.SwipeAdjustment.veryBig)
    }
    
    func testOpenDeveloperOptions() {
        homePage.openDeveloperOptions()
    }
}
