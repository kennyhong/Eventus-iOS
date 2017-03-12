import XCTest

class EventListTests: XCTestCase {
	
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
		return wasLoggedIn
	}
	
	private func teardown(_ wasLoggedIn: Bool) {
		if !wasLoggedIn {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
	}
	
    func testNavBarTitle() {
		let wasLoggedIn = setup()
		XCTAssertNotNil(app.navigationBars["Events"])
		teardown(wasLoggedIn)
    }
	
	func testNoData() {
		let wasLoggedIn = setup()
		XCTAssertEqual(app.tables.cells.count, 0)
		teardown(wasLoggedIn)
	}
}
