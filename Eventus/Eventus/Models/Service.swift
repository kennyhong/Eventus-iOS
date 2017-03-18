import UIKit

class Service: NSObject {
	
	var id: Int?
	var name: String?
	var cost: Double?
	
	init(id: Int? = nil,
	     name: String? = nil,
	     cost: Double? = nil) {
		
		self.id = id
		self.name = name
		self.cost = cost
	}
}
