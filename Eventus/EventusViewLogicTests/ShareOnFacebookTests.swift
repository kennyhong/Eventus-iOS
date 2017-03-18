import XCTest

class ShareOnFacebookTests: XCTestCase {
	
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
	
	func testInvoiceButtonExists() {
		let wasLoggedIn = setup()
		let shareOnFacebookButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .button).element
		XCTAssertNotNil(shareOnFacebookButton)
		teardown(wasLoggedIn)
	}
	
	func testComponentVisiblity() {
		let wasLoggedIn = setup()
		let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
		let shareOnFacebookButton = element.children(matching: .other).element(boundBy: 2).children(matching: .button).element
		shareOnFacebookButton.tap()
		XCTAssertTrue(app.navigationBars["Share Event on Facebook"].staticTexts["Share Event on Facebook"].exists)
		XCTAssertTrue(app.staticTexts["Sharing on Facebook will post the below image, allowing Eventus users to scan the QR code to add your event to their iOS calendar"].exists)
		XCTAssertTrue(element.children(matching: .other).element.children(matching: .image).element.exists)
		app.buttons["Share on Facebook"].tap()
		app.navigationBars["Facebook"].buttons["Cancel"].tap()
		teardown(wasLoggedIn)
	}
}
