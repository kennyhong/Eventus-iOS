import UIKit

public enum ServiceSortState: Int {
	case nameAscending
	case nameDescending
	case costAscending
	case costDescending
}

class ServiceFilteringSettings {
	
	static let shared : ServiceFilteringSettings = {
		return ServiceFilteringSettings()
	}()
	
	var sortState: ServiceSortState = .nameAscending
	var selectedTags: [Tag] = []
	
	var orderByString: String {
		get {
			var orderByString: String
			var orderType: String
			switch sortState {
				case .nameAscending:
					orderByString = "name"
					orderType = "ASC"
				case .nameDescending:
					orderByString = "name"
					orderType = "DESC"
				case .costAscending:
					orderByString = "cost"
					orderType = "ASC"
				case .costDescending:
					orderByString = "cost"
					orderType = "DESC"
			}
			return "order-by=\(orderByString)&order=\(orderType)"
		}
	}
	
	var tagFilterString: String {
		get {
			var idsString = ""
			for tag in selectedTags {
				if idsString.isEmpty {
					idsString = "\(tag.id!)"
				} else {
					idsString = "\(idsString),\(tag.id!)"
				}
			}
			if idsString.isEmpty {
				return ""
			}
			return "filter-tag-ids=\(idsString)"
		}
	}
}
