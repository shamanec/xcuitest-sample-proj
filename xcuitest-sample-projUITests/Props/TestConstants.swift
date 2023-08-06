//
//  TestConstants.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 18.07.23.
//

import CoreGraphics

struct TestConstants {
    /**
     This enum contains the timeout values that can be used in any wait functions
     - veryShort = 3.0
     - short = 5.0
     - medium = 10.0
     - mediumLong = 15.0
     - longShortShort = 20.0
     - long = 30.0
     - longMedium = 35.0
     - longLong = 40.0
     - longExtran = 50.0
     */
    enum Timeout {
        static let second = 1.0
        static let veryShort = 3.0
        static let short = 5.0
        static let medium = 10.0
        static let mediumLong = 15.0
        static let longShortShort = 20.0
        static let longShort = 25.0
        static let long = 30.0
        static let longMedium = 35.0
        static let longLong = 40.0
        static let longExtra = 50.0
    }
    
    /**
     This enum contains the values that can be used by `gentleSwipeUntil` and  `gentleSwipe` functions.
     Use them to define how 'big' should be the performed swiped when calling the functions, default is `normal`
     - small: 0.05 CGFloat
     - medium: 0.15 CGFloat
     - normal: 0.25 CGFloat
     - big: 0.35 CGFloat
     */
    enum SwipeAdjustment {
        static let small: CGFloat = 0.05
        static let medium: CGFloat = 0.15
        static let normal: CGFloat = 0.25
        static let big: CGFloat = 0.35
        static let veryBig: CGFloat = 0.45
    }
    
    /**
     This enum contains the possible swipe directions
     - up
     - down
     - left
     - right
     */
    enum Direction: Int {
        case up, down, left, right
    }
    
    /**
     This enum contains the relative element position options
     - leftOf
     - rightOf
     - above
     - below
     */
    enum ElementPosition: Int {
        case leftOf
        case rightOf
        case above
        case below
    }
}

