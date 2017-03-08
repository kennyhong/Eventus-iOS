//
//  ProfileTests.swift
//  Eventus
//
//  Created by Kieran on 2017-02-21.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import XCTest

class ProfileTests: XCTestCase {
	
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
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
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
	
    func testLogoutButtonExists() {
		XCTAssertNotNil(app.buttons["Logout"])
    }
}
