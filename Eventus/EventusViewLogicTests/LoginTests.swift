import XCTest

class LoginTests: XCTestCase {
	
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
		
		// Ensure logged out for testing
		if app.navigationBars.count > 0 {
			wasLoggedIn = true
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			prevUsername = app.navigationBars.element(boundBy: 0).value(forKey: "identifier") as? String
			prevUsername = prevUsername == "Eventus.ProfileView" ? "testuser" : prevUsername
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
		
		return (wasLoggedIn, prevUsername)
	}
	
	private func teardown(_ wasLoggedIn: Bool, _ tearDownShouldLogout: Bool, _ prevUsername: String? = nil) {
		if tearDownShouldLogout {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
		
		if wasLoggedIn {
			app.textFields["Username"].tap()
			app.typeText(prevUsername!)
			app.buttons[">"].tap()
		}
	}
    
    func testNoUserLoginButton1Attempt() {
		let (wasLoggedIn, prevUsername) = setup()
		app.buttons[">"].tap()
		XCTAssertTrue(app.staticTexts["Eventus"].exists)
		teardown(wasLoggedIn, false, prevUsername)
    }
	
	func testNoUserLoginButton2Attempt() {
		let (wasLoggedIn, prevUsername) = setup()
		app.textFields["Username"].tap()
		app.keyboards.buttons["Go"].tap()
		XCTAssertTrue(app.staticTexts["Eventus"].exists)
		teardown(wasLoggedIn, false, prevUsername)
	}
	
	func testShowHideKeyboard() {
		let (wasLoggedIn, prevUsername) = setup()
		app.textFields["Username"].tap()
		XCTAssertEqual(app.keyboards.count, 1)
		app.staticTexts["Eventus"].tap()
		XCTAssertEqual(app.keyboards.count, 0)
		teardown(wasLoggedIn, false, prevUsername)
	}
	
	func testValidLoginButton1() {
		let (wasLoggedIn, prevUsername) = setup()
		app.textFields["Username"].tap()
		app.typeText("testuser1")
		app.buttons[">"].tap()
		XCTAssertTrue(app.navigationBars["Events"].staticTexts["Events"].exists)
		teardown(wasLoggedIn, true, prevUsername)
	}
	
	func testValidLoginButton2() {
		let (wasLoggedIn, prevUsername) = setup()
		app.textFields["Username"].tap()
		app.typeText("testuser2")
		app.keyboards.buttons["Go"].tap()
		XCTAssertTrue(app.navigationBars["Events"].staticTexts["Events"].exists)
		teardown(wasLoggedIn, true, prevUsername)
	}
}
