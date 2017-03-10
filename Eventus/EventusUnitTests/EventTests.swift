import XCTest

class EventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNoParameterConstructor() {
		let event = Event()
		XCTAssertNil(event.id)
		XCTAssertNil(event.name)
		XCTAssertNil(event.eventDescription)
		XCTAssertNil(event.date)
    }
	
	func testPartialParameterConstructor() {
		let event = Event(name: "name-test", eventDescription: "test-description")
		XCTAssertNil(event.id)
		XCTAssertNotNil(event.name)
		XCTAssertNotNil(event.eventDescription)
		XCTAssertNil(event.date)
		
		XCTAssertEqual(event.name, "name-test")
		XCTAssertEqual(event.eventDescription, "test-description")
	}
	
	func testFullParameterConstructor() {
		let event = Event(id: 1, name: "name-test", eventDescription: "test-description", date: "test-date")
		XCTAssertNotNil(event.id)
		XCTAssertNotNil(event.name)
		XCTAssertNotNil(event.eventDescription)
		XCTAssertNotNil(event.date)
		
		XCTAssertEqual(event.id, 1)
		XCTAssertEqual(event.name, "name-test")
		XCTAssertEqual(event.eventDescription, "test-description")
		XCTAssertEqual(event.date, "test-date")
	}
}
