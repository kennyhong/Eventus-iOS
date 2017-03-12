import XCTest

class EventDetailsTests: XCTestCase {
        
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
			app.navigationBars["Events"].staticTexts["Events"].tap()
		}
		
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels["2017"].adjust(toPickerWheelValue: "2018")
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
	
	func testEventDetailsLayout() {
		let wasLoggedIn = setup()
		app.navigationBars["Event Details"].staticTexts["Event Details"].tap()
		app.staticTexts["test-title"].tap()
		app.staticTexts["test-description"].tap()
		let servicesButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element
		servicesButton.tap()
		app.navigationBars["Current Services"].buttons["Event Details"].tap()
		teardown(wasLoggedIn)
	}
	
	func testDeleteEvent() {
		let wasLoggedIn = setup()
		app.buttons["Delete Event"].tap()
		app.alerts["Delete Event"].buttons["Delete"].tap()
		app.navigationBars["Events"].staticTexts["Events"].tap()
		XCTAssertFalse(app.staticTexts["test-title"].exists)
		teardown(wasLoggedIn)
	}
}
