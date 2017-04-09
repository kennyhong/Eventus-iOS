import XCTest

class ServiceFilteringTests: XCTestCase {
	
	fileprivate let app = XCUIApplication()
	
	override func setUp() {
		super.setUp()
		continueAfterFailure = false
		app.launchEnvironment = ["isTest":"true"]
		app.launch()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	private func setup() -> Bool {
		var wasLoggedIn = true
		if app.navigationBars.count <= 0 {
			wasLoggedIn = false
			app.textFields["Username"].tap()
			app.typeText("testuser1")
			app.buttons[">"].tap()
		}
		return wasLoggedIn
	}
	
	private func teardown(_ wasLoggedIn: Bool) {
		if !wasLoggedIn {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.navigationBars["Service Filtering"].buttons["Back"].tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
	}
	
	func testServiceFilteringLayout() {
		let wasLoggedIn = setup()
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		XCTAssertTrue(app.navigationBars["Service Filtering"].staticTexts["Service Filtering"].exists)
		XCTAssertTrue(app.staticTexts["Service Sorting"].exists)
		XCTAssertTrue(app.staticTexts["Filter Services"].exists)
		teardown(wasLoggedIn)
	}
	
	func testSortNameAscending() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		
		app.navigationBars["Current Services"].buttons["plus"].tap()
		XCTAssertTrue(app.tables.cells.element(boundBy: 0).staticTexts["test-add-service"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 1).staticTexts["test-add-service2"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 2).staticTexts["test-add-service3"].exists)
		teardown(wasLoggedIn)
	}
	
	func testSortNameDescending() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		let button = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element
		button.tap()
		button.tap()
		app.tabBars.children(matching: .button).element(boundBy: 0).tap()
		
		app.navigationBars["Current Services"].buttons["plus"].tap()
		XCTAssertTrue(app.tables.cells.element(boundBy: 0).staticTexts["test-add-service3"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 1).staticTexts["test-add-service2"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 2).staticTexts["test-add-service"].exists)
		teardown(wasLoggedIn)
	}
	
	func testSortCostAscending() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		let costButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		costButton.tap()
		app.tabBars.children(matching: .button).element(boundBy: 0).tap()
		
		app.navigationBars["Current Services"].buttons["plus"].tap()
		XCTAssertTrue(app.tables.cells.element(boundBy: 0).staticTexts["cost: $50.0"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 1).staticTexts["cost: $100.0"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 2).staticTexts["cost: $150.0"].exists)
		teardown(wasLoggedIn)
	}
	
	func testSortCostDescending() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		let costButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		costButton.tap()
		costButton.tap()
		app.tabBars.children(matching: .button).element(boundBy: 0).tap()
		
		app.navigationBars["Current Services"].buttons["plus"].tap()
		XCTAssertTrue(app.tables.cells.element(boundBy: 0).staticTexts["cost: $150.0"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 1).staticTexts["cost: $100.0"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 2).staticTexts["cost: $50.0"].exists)
		teardown(wasLoggedIn)
	}
	
	func testSingleTagFilter() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		app.tables.staticTexts["test-tag-1"].tap()
		app.tabBars.children(matching: .button).element(boundBy: 0).tap()
		
		app.navigationBars["Current Services"].buttons["plus"].tap()
		XCTAssertTrue(app.tables.cells.element(boundBy: 0).staticTexts["test-add-service"].exists)
		XCTAssertFalse(app.tables.cells.staticTexts["test-add-service2"].exists)
		XCTAssertFalse(app.tables.cells.staticTexts["test-add-service3"].exists)
		teardown(wasLoggedIn)
	}
	
	func testMultiTagFilter() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
		app.tables.staticTexts["test-tag-1"].tap()
		app.tables.staticTexts["test-tag-2"].tap()
		app.tabBars.children(matching: .button).element(boundBy: 0).tap()
		
		app.navigationBars["Current Services"].buttons["plus"].tap()
		XCTAssertTrue(app.tables.cells.element(boundBy: 0).staticTexts["test-add-service"].exists)
		XCTAssertTrue(app.tables.cells.element(boundBy: 1).staticTexts["test-add-service2"].exists)
		XCTAssertFalse(app.tables.cells.staticTexts["test-add-service3"].exists)
		teardown(wasLoggedIn)
	}
}
