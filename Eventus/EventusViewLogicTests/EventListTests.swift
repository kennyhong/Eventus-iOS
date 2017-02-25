//
//  EventListTests.swift
//  Eventus
//
//  Created by Kieran on 2017-02-21.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import XCTest

class EventListTests: XCTestCase {
	
	fileprivate let app = XCUIApplication()
	fileprivate var wasLoggedIn: Bool?
	
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
		
		wasLoggedIn = true
    }
    
    override func tearDown() {
        super.tearDown()
		if !wasLoggedIn! {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
    }
    
    func testNavBarTitle() {
		if app.navigationBars.count <= 0 {
			wasLoggedIn = false
			app.textFields["Username"].tap()
			app.typeText("testuser1")
			app.buttons[">"].tap()
			app.navigationBars["Events"].staticTexts["Events"].tap()
		}
		XCTAssertNotNil(app.navigationBars["Events"])
    }
	
	func testNoData() {
		let eventListViewController = EventListViewController()
		eventListViewController.rowData = []
		XCTAssertEqual(eventListViewController.rowData, [])
		XCTAssertEqual(eventListViewController.rowData.count, 0)
		XCTAssertEqual(eventListViewController.tableView.numberOfRows(inSection: 0), 0)
	}
	
	func testRowData() {
		let eventListViewController = EventListViewController()
		eventListViewController.rowData = []
		let event1 = Event(name: "My Wedding", eventDescription: "test description")
		let event2 = Event(name: "My BBQ", eventDescription: "BBQ at my house", date: "1000-01-01 11:12:12")
		eventListViewController.rowData.append(event1)
		eventListViewController.rowData.append(event2)
		XCTAssertEqual(eventListViewController.rowData.count, 2)
		XCTAssertEqual(eventListViewController.tableView.numberOfRows(inSection: 0), 2)
	}
}
