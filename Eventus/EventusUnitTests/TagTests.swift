import XCTest

class TagTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testNoParameterConstructor() {
		let tag = Tag()
		XCTAssertNil(tag.id)
		XCTAssertNil(tag.tag)
		XCTAssertNotNil(tag.isSelected)
		
		XCTAssertEqual(tag.isSelected, false)
	}
	
	func testPartialParameterConstructor() {
		let tag = Tag(id: 1, tag: "test-tag")
		XCTAssertNotNil(tag.id)
		XCTAssertNotNil(tag.tag)
		XCTAssertNotNil(tag.isSelected)
		
		XCTAssertEqual(tag.id, 1)
		XCTAssertEqual(tag.tag, "test-tag")
		XCTAssertEqual(tag.isSelected, false)
	}
	
	func testFullParameterConstructor() {
		let tag = Tag(id: 1, tag: "test-tag", isSelected: true)
		XCTAssertNotNil(tag.id)
		XCTAssertNotNil(tag.tag)
		XCTAssertNotNil(tag.isSelected)
		
		XCTAssertEqual(tag.id, 1)
		XCTAssertEqual(tag.tag, "test-tag")
		XCTAssertEqual(tag.isSelected, true)
	}
}
