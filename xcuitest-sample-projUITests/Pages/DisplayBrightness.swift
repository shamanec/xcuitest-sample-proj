//
//  DisplayBrightness.swift
//  xcuitest-sample-projUITests
//
//  Created by Nikola Shabanov on 19.07.23.
//

import XCTest

class DisplayBrightness: Base {
    private var brightnessSlider: XCUIElement { app.sliders.element(withLabelContaining: "brightness")}
    
    func setBrightnessMax() {
        brightnessSlider.adjust(toNormalizedSliderPosition: 1)
    }
    
    func setBrightnessMin() {
        brightnessSlider.adjust(toNormalizedSliderPosition: 0)
    }
    
    func setBrightnessHalf() {
        brightnessSlider.adjust(toNormalizedSliderPosition: 0.5)
    }
}
