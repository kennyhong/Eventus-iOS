import XCTest

class AddEventTests: XCTestCase {
	
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
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
	}
	
	func testInvalidAddEvent() {
		let wasLoggedIn = setup()
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Description"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.alerts["Incomplete Event"].buttons["Continue"].tap()
		teardown(wasLoggedIn)
	}
	
	func testValidAddEvent() {
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
		app.navigationBars["Event Details"].buttons["Events"].tap()
		teardown(wasLoggedIn)
	}
}
