//
//  Service.swift
//  Eventus
//
//  Created by Kieran on 2017-03-03.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class Service: NSObject {
	
	var id: Int?
	var name: String?
	var cost: Int?
	
	init(id: Int? = nil,
	     name: String? = nil,
	     cost: Int? = nil) {
		
		self.id = id
		self.name = name
		self.cost = cost
	}
}
