import XCTest

class LogoutTests: XCTestCase {
	
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
	
	private func setup() -> (Bool, String?) {
		var wasLoggedIn = false
		var prevUsername: String?
		
		if app.navigationBars.count > 0 {
			wasLoggedIn = true
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			prevUsername = app.navigationBars.element(boundBy: 0).value(forKey: "identifier") as? String
		}
		
		if !wasLoggedIn {
			app.textFields["Username"].tap()
			app.typeText("testuser1")
			app.buttons[">"].tap()
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
		}
		
		return (wasLoggedIn, prevUsername)
	}
	
	private func teardown(_ wasLoggedIn: Bool, _ prevUsername: String? = nil) {
		if wasLoggedIn {
			app.textFields["Username"].tap()
			app.typeText(prevUsername!)
			app.buttons[">"].tap()
		}
	}
    
    func testLogout() {
		let (wasLoggedIn, prevUsername) = setup()
		app.buttons["Logout"].tap()
		app.alerts["Logout"].buttons["Logout"].tap()
		teardown(wasLoggedIn, prevUsername)
    }
}
