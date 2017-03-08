//
//  LogoutTests.swift
//  Eventus
//
//  Created by Kieran on 2017-02-19.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import XCTest

class LogoutTests: XCTestCase {
	
	fileprivate let app = XCUIApplication()
	fileprivate var wasLoggedIn: Bool?
	fileprivate var prevUsername: String?
	
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
		app.launchEnvironment = ["isTest":"true"]
        app.launch()
		
		wasLoggedIn = false
		if app.navigationBars.count > 0 {
			wasLoggedIn = true
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			prevUsername = app.navigationBars.element(boundBy: 0).value(forKey: "identifier") as? String
		}
		
		if !wasLoggedIn! {
			app.textFields["Username"].tap()
			app.typeText("testuser1")
			app.buttons[">"].tap()
			app.navigationBars["Events"].staticTexts["Events"].tap()
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		}
    }
    
    override func tearDown() {
        super.tearDown()
		
		if wasLoggedIn! {
			app.textFields["Username"].tap()
			app.typeText(prevUsername!)
			app.buttons[">"].tap()
			app.navigationBars["Events"].staticTexts["Events"].tap()
		}
    }
    
    func testLogout() {
		app.buttons["Logout"].tap()
		app.alerts["Logout"].buttons["Logout"].tap()
    }
    
}
