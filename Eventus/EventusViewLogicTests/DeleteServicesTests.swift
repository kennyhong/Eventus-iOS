import XCTest

class DeleteServicesTests: XCTestCase {
        
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
		let servicesButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element
		servicesButton.tap()
		return wasLoggedIn
	}
	
	private func teardown(_ wasLoggedIn: Bool) {
		if !wasLoggedIn {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
	}
	
	func testDeleteService() {
		let wasLoggedIn = setup()
		app.navigationBars["Current Services"].buttons["plus"].tap()
		app.tables.staticTexts["test-add-service"].tap()
		app.buttons["Add Service"].tap()
		app.navigationBars["Add Services"].buttons["Done"].tap()
		
		app.tables.cells.element(boundBy: 0).tap()
		XCTAssertTrue(app.navigationBars["Service Details"].staticTexts["Service Details"].exists)
		app.buttons["Delete Service"].tap()
		app.alerts["Remove Service"].buttons["Remove"].tap()
		XCTAssertTrue(app.navigationBars["Current Services"].staticTexts["Current Services"].exists)
		XCTAssertFalse(app.tables.staticTexts["test-service"].exists)
		teardown(wasLoggedIn)
	}
}
