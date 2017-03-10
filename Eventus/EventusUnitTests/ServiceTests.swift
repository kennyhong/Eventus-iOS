import XCTest

class ServiceTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
	
	func testNoParameterConstructor() {
		let service = Service()
		XCTAssertNil(service.id)
		XCTAssertNil(service.name)
		XCTAssertNil(service.cost)
	}
	
	func testPartialParameterConstructor() {
		let service = Service(name: "name-test", cost: 100)
		XCTAssertNil(service.id)
		XCTAssertNotNil(service.name)
		XCTAssertNotNil(service.cost)
		
		XCTAssertEqual(service.name, "name-test")
		XCTAssertEqual(service.cost, 100)
	}
	
	func testFullParameterConstructor() {
		let service = Service(id: 1, name: "name-test", cost: 100)
		XCTAssertNotNil(service.id)
		XCTAssertNotNil(service.name)
		XCTAssertNotNil(service.cost)
		
		XCTAssertEqual(service.id, 1)
		XCTAssertEqual(service.name, "name-test")
		XCTAssertEqual(service.cost, 100)
	}
}
