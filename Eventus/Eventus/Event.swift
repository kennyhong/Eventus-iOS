//
//  Event.swift
//  Eventus
//
//  Created by Kieran on 2017-02-09.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class Event: NSObject {
	
	var name: String?
	var eventDescription: String?
	var date: String?
	var services: [String]
	
	init(name: String? = nil,
	     eventDescription: String? = nil,
	     date: String? = nil,
	     services: [String] = []) {
		
		self.name = name
		self.eventDescription = eventDescription
		self.date = date
		self.services = services
	}
}
