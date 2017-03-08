//
//  AddEventTests.swift
//  Eventus
//
//  Created by Kieran on 2017-03-08.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import XCTest

class AddEventTests: XCTestCase {
	
	fileprivate let app = XCUIApplication()
	fileprivate var wasLoggedIn: Bool?
	
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
		app.launchEnvironment = ["isTest":"true"]
        app.launch()
		
		wasLoggedIn = true
		if app.navigationBars.count <= 0 {
			wasLoggedIn = false
			app.textFields["Username"].tap()
			app.typeText("testuser1")
			app.buttons[">"].tap()
			app.navigationBars["Events"].staticTexts["Events"].tap()
		}
    }
    
    override func tearDown() {
        super.tearDown()
		if !wasLoggedIn! {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
    }
	
	func testInvalidAddEvent() {
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Description"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels["2017"].adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.alerts["Incomplete Event"].buttons["Continue"].tap()
	}
	
	func testValidAddEvent() {
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels["2017"].adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.navigationBars["Event Details"].buttons["Events"].tap()
	}
}
