import XCTest

class LoginTests: XCTestCase {
	
	private var app = XCUIApplication()
	private var prevUsername: String?
	private var wasLoggedIn: Bool = false
	private var tearDownShouldLogout: Bool?
	
    override func setUp() {
        super.setUp()
		
		continueAfterFailure = false
		app.launchEnvironment = ["isTest":"true"]
		app.launch()
		
		tearDownShouldLogout = false
		wasLoggedIn = false
		
		// Ensure logged out for testing
		if app.navigationBars.count > 0 {
			wasLoggedIn = true
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			prevUsername = app.navigationBars.element(boundBy: 0).value(forKey: "identifier") as? String
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
    }
    
    override func tearDown() {
        super.tearDown()
		if tearDownShouldLogout != nil && tearDownShouldLogout! {
			app.tabBars.children(matching: .button).element(boundBy: 1).tap()
			app.buttons["Logout"].tap()
			app.alerts["Logout"].buttons["Logout"].tap()
		}
		
		if wasLoggedIn {
			app.textFields["Username"].tap()
			app.typeText(prevUsername!)
			app.buttons[">"].tap()
			app.navigationBars["Events"].staticTexts["Events"].tap()
		}
    }
    
    func testNoUserLoginButton1Attempt() {
		app.buttons[">"].tap()
		app.staticTexts["Eventus"].tap()
    }
	
	func testNoUserLoginButton2Attempt() {
		app.textFields["Username"].tap()
		app.keyboards.buttons["Go"].tap()
		app.staticTexts["Eventus"].tap()
	}
	
	func testShowHideKeyboard() {
		app.textFields["Username"].tap()
		XCTAssertEqual(app.keyboards.count, 1)
		app.staticTexts["Eventus"].tap()
		XCTAssertEqual(app.keyboards.count, 0)
	}
	
	func testValidLoginButton1() {
		app.textFields["Username"].tap()
		app.typeText("testuser1")
		app.buttons[">"].tap()
		app.navigationBars["Events"].staticTexts["Events"].tap()
		tearDownShouldLogout = true
	}
	
	func testValidLoginButton2() {
		app.textFields["Username"].tap()
		app.typeText("testuser2")
		app.keyboards.buttons["Go"].tap()
		app.navigationBars["Events"].staticTexts["Events"].tap()
		tearDownShouldLogout = true
	}
}
