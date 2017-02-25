//
//  EventTests.swift
//  Eventus
//
//  Created by Kieran on 2017-02-17.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

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
		XCTAssertNil(event.name)
		XCTAssertNil(event.eventDescription)
		XCTAssertNil(event.date)
		XCTAssertNotNil(event.services)
		
		XCTAssertEqual(event.services, [])
    }
	
	func testPartialParameterConstructor() {
		let event = Event(name: "name-test", eventDescription: "test-description")
		XCTAssertNotNil(event.name)
		XCTAssertNotNil(event.eventDescription)
		XCTAssertNil(event.date)
		XCTAssertNotNil(event.services)
		
		XCTAssertEqual(event.name, "name-test")
		XCTAssertEqual(event.eventDescription, "test-description")
		XCTAssertEqual(event.services, [])
	}
	
	func testFullParameterConstructor() {
		let event = Event(name: "name-test", eventDescription: "test-description", date: "test-date", services: ["test-service"])
		XCTAssertNotNil(event.name)
		XCTAssertNotNil(event.eventDescription)
		XCTAssertNotNil(event.date)
		XCTAssertNotNil(event.services)
		
		XCTAssertEqual(event.name, "name-test")
		XCTAssertEqual(event.eventDescription, "test-description")
		XCTAssertEqual(event.date, "test-date")
		XCTAssertEqual(event.services, ["test-service"])
	}
}
