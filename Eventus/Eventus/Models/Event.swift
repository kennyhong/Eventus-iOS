import UIKit

class Event: NSObject {
	
	var id: Int?
	var name: String?
	var eventDescription: String?
	var date: String?
	var subTotal: Double?
	var tax: Double?
	var total: Double?
	var services: [Service]
	
	init(id: Int? = nil,
	     name: String? = nil,
	     eventDescription: String? = nil,
	     date: String? = nil,
	     subTotal: Double? = 0.0,
	     tax: Double? = 0.0,
	     total: Double? = 0.0,
	     services: [Service]? = []) {
		
		self.id = id
		self.name = name
		self.eventDescription = eventDescription
		self.date = date
		self.subTotal = subTotal
		self.tax = tax
		self.total = total
		self.services = services!
	}
}
