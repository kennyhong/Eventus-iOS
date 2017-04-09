import UIKit

class Tag: NSObject {
	
	var id: Int?
	var tag: String?
	var isSelected: Bool?
	
	init(id: Int? = nil,
	     tag: String? = nil,
	     isSelected: Bool? = false) {
		
		self.id = id
		self.tag = tag
		self.isSelected = isSelected
	}
}
