import XCTest

class ProfileTests: XCTestCase {
	
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
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
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
	
	func testServiceFilteringButtonExists() {
		let wasLoggedIn = setup()
		app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		let button = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element
		XCTAssertNotNil(button)
		teardown(wasLoggedIn)
	}
	
	func testQrCodeButtonExists() {
		let wasLoggedIn = setup()
		let button = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .button).element
		XCTAssertNotNil(button)
		teardown(wasLoggedIn)
	}
	
	func testLogoutButtonExists() {
		let wasLoggedIn = setup()
		XCTAssertNotNil(app.buttons["Logout"])
		teardown(wasLoggedIn)
	}
}
