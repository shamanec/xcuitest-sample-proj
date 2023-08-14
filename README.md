# XCUITest sample project

This is a sample project that demonstrates testing with XCUITest, using a basic Page Object Model structure, with multiple helper and utility methods that I've created or used during my work with XCUITest  
It serves more as a demonstration of XCUITest than POM which is just a simple example for structuring tests without any coding bells and whistles.

## Highlights
### Interaction helper methods
Can be found in `Helpers/Interaction.swift`
Multiple utility methods for pressing the Home button, drag and dropping elements, performing normal or gentler swipes, also swipes until a condition is satisfied (useful for lazy loading elements)

### Alert helper methods
Can be found in `Helpers/Alert.swift`
Multiple overloaded methods to handle expected application or system alerts

### App helper methods
Can be found in `Helpers/App.swift`
Helper methods for backgrounding, forwarding, terminating, restarting or deleting the AUT.

### Element helper methods
Different waiting approaches using polling or XCTWaiter for existence, labels and others. Setting slider or picker values. Validating relative element to element position

## Target app
The tests target a sample app I've built using Google and ChatGPT because I am not an app developer, but its sufficient for demonstration  
