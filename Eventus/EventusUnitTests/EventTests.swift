import XCTest

class EventTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNoParameterConstructor() {
		let event = Event()
		XCTAssertNil(event.id)
		XCTAssertNil(event.name)
		XCTAssertNil(event.eventDescription)
		XCTAssertNil(event.date)
		XCTAssertEqual(event.tax, 0.0)
		XCTAssertEqual(event.subTotal, 0.0)
		XCTAssertEqual(event.total, 0.0)
		XCTAssertEqual(event.services, [])
    }
	
	func testPartialParameterConstructor() {
		let event = Event(name: "name-test", eventDescription: "test-description")
		XCTAssertNil(event.id)
		XCTAssertNotNil(event.name)
		XCTAssertNotNil(event.eventDescription)
		XCTAssertNil(event.date)
		XCTAssertEqual(event.tax, 0.0)
		XCTAssertEqual(event.subTotal, 0.0)
		XCTAssertEqual(event.total, 0.0)
		XCTAssertEqual(event.services, [])
		
		XCTAssertEqual(event.name, "name-test")
		XCTAssertEqual(event.eventDescription, "test-description")
	}
	
	func testFullParameterConstructor() {
		let event = Event(id: 1, name: "name-test", eventDescription: "test-description", date: "test-date", subTotal: 20.0, tax: 3.5, total: 23.5, services: [Service()])
		XCTAssertNotNil(event.id)
		XCTAssertNotNil(event.name)
		XCTAssertNotNil(event.eventDescription)
		XCTAssertNotNil(event.date)
		XCTAssertNotNil(event.subTotal)
		XCTAssertNotNil(event.tax)
		XCTAssertNotNil(event.subTotal)
		XCTAssertNotNil(event.total)
		XCTAssertNotNil(event.services)
		
		XCTAssertEqual(event.id, 1)
		XCTAssertEqual(event.name, "name-test")
		XCTAssertEqual(event.eventDescription, "test-description")
		XCTAssertEqual(event.date, "test-date")
		XCTAssertEqual(event.subTotal, 20.0)
		XCTAssertEqual(event.tax, 3.5)
		XCTAssertEqual(event.total, 23.5)
		XCTAssertEqual(event.services[0].id, Service().id)
		XCTAssertEqual(event.services[0].name, Service().name)
		XCTAssertEqual(event.services[0].cost, Service().cost)
	}
}
