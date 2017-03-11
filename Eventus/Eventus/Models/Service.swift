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
