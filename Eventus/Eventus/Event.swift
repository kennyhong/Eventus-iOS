import UIKit

class Event: NSObject {
	
	var id: Int?
	var name: String?
	var eventDescription: String?
	var date: String?
	
	init(id: Int? = nil,
	     name: String? = nil,
	     eventDescription: String? = nil,
	     date: String? = nil) {
		
		self.id = id
		self.name = name
		self.eventDescription = eventDescription
		self.date = date
	}
}
