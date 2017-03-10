import XCTest

class UserTests: XCTestCase {
	
	private var user: User?
	
    override func setUp() {
        super.setUp()
		user = User()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInitUser() {
		XCTAssertNotNil(user)
		XCTAssertNil(user?.username)
		XCTAssertNil(user?.isLoggedIn)
    }
	
	func testSetIsLoggedIn() {
		user?.isLoggedIn = true
		XCTAssertNotNil(user?.isLoggedIn)
		XCTAssertTrue(user!.isLoggedIn!)
	}
	
	func testSetUsername() {
		user?.username = "test-user"
		XCTAssertNotNil(user?.username)
		XCTAssertEqual(user!.username!, "test-user")
	}
}
