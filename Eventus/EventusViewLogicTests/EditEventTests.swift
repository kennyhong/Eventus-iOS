import XCTest

class EditEventTests: XCTestCase {
	
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
		
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "January")
		app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "1")
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		
		return wasLoggedIn
	}
	
	private func teardown(_ wasLoggedIn: Bool) {
		if !wasLoggedIn {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
	}
	
	func testEditButtonExists() {
		let wasLoggedIn = setup()
		XCTAssertNotNil(app.navigationBars["Event Details"].buttons["Edit"])
		teardown(wasLoggedIn)
	}
	
	func testEditName() {
		let wasLoggedIn = setup()
		app.navigationBars["Event Details"].buttons["Edit"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("-edit")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		XCTAssertNotNil(app.tables.staticTexts["test-title-edit"])
		XCTAssertNotNil(app.navigationBars["Event Details"].buttons["Events"])
		teardown(wasLoggedIn)
	}
	
	func testEditDescription() {
		let wasLoggedIn = setup()
		app.navigationBars["Event Details"].buttons["Edit"].tap()
		app.textFields["Description"].tap()
		app.textFields["Description"].typeText("-edit")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		XCTAssertNotNil(app.tables.staticTexts["test-description-edit"])
		XCTAssertNotNil(app.navigationBars["Event Details"].buttons["Events"])
		teardown(wasLoggedIn)
	}
	
	func testEditDate() {
		let wasLoggedIn = setup()
		app.navigationBars["Event Details"].buttons["Edit"].tap()
		app.textFields["Description"].tap()
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2019")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		XCTAssertNotNil(app.tables.staticTexts["Jan 1, 2019"])
		XCTAssertNotNil(app.navigationBars["Event Details"].buttons["Events"])
		teardown(wasLoggedIn)
	}
}
