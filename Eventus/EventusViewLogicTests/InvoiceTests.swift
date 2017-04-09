import XCTest

class InvoiceTests: XCTestCase {
	
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
		let invoiceButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		XCTAssertNotNil(invoiceButton)
		teardown(wasLoggedIn)
	}
	
	func testInvoiceLayout() {
		let wasLoggedIn = setup()
		let invoiceButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		invoiceButton.tap()
		XCTAssertNotNil(app.navigationBars["Event Details"].buttons["Event Invoice"])
		XCTAssertNotNil(app.staticTexts["Service"])
		XCTAssertNotNil(app.staticTexts["Cost"])
		XCTAssertNotNil(app.staticTexts["Subtotal"])
		XCTAssertNotNil(app.staticTexts["Tax"])
		XCTAssertNotNil(app.staticTexts["Total"])
		teardown(wasLoggedIn)
	}
	
	func testInvoiceSummary() {
		let wasLoggedIn = setup()
		let invoiceButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		invoiceButton.tap()
		
		let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element
		XCTAssertTrue(element.children(matching: .other).element(boundBy: 0).staticTexts["$0.0"].exists)
		XCTAssertTrue(element.children(matching: .other).element(boundBy: 1).staticTexts["$0.0"].exists)
		XCTAssertTrue(element.children(matching: .other).element(boundBy: 2).staticTexts["$0.0"].exists)
		teardown(wasLoggedIn)
	}
	
	func testNonEmptyInvoice() {
		let wasLoggedIn = setup()
		let servicesButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element
		servicesButton.tap()
		app.navigationBars["Current Services"].buttons["plus"].tap()
		
		XCTAssertEqual(app.tables.cells.count,3)
		app.tables.staticTexts["test-add-service"].tap()
		app.buttons["Add Service"].tap()
		XCTAssertEqual(app.tables.cells.count,2)
		app.navigationBars["Add Services"].buttons["Done"].tap()
		XCTAssertTrue(app.staticTexts["test-add-service"].exists)
		app.navigationBars["Current Services"].buttons["Event Details"].tap()
		
		let invoiceButton = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		invoiceButton.tap()
		
		let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element
		XCTAssertTrue(app.staticTexts["test-add-service"].exists)
		XCTAssertTrue(app.staticTexts["$100.0"].exists)
		XCTAssertTrue(element.children(matching: .other).element(boundBy: 0).staticTexts["$100.0"].exists)
		XCTAssertTrue(element.children(matching: .other).element(boundBy: 1).staticTexts["$13.0"].exists)
		XCTAssertTrue(element.children(matching: .other).element(boundBy: 2).staticTexts["$113.0"].exists)
		
		teardown(wasLoggedIn)
	}
}
