import XCTest

class DeleteServicesTests: XCTestCase {
        
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
		
		app.navigationBars["Events"].buttons["plus"].tap()
		app.textFields["Name"].tap()
		app.textFields["Name"].typeText("test-title")
		app.buttons["Next:"].tap()
		app.textFields["Description"].typeText("test-description")
		app.buttons["Next:"].tap()
		app.pickerWheels["2017"].adjust(toPickerWheelValue: "2018")
		app.navigationBars["Add Event"].buttons["Save"].tap()
		app.tables.staticTexts["test-title"].tap()
		let servicesButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element
		servicesButton.tap()
	}
	
	override func tearDown() {
		super.tearDown()
		if !wasLoggedIn! {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
	}
	
	func testDeleteService() {
		app.tables.staticTexts["test-service"].tap()
		app.navigationBars["Service Details"].staticTexts["Service Details"].tap()
		app.buttons["Delete Service"].tap()
		app.alerts["Remove Service"].buttons["Remove"].tap()
		app.navigationBars["Current Services"].staticTexts["Current Services"].tap()
		XCTAssertFalse(app.tables.staticTexts["test-service"].exists)
	}
}
