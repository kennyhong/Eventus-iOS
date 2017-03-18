import UIKit

extension DateFormatter {
	
	func englishDate(from jsonDateString: String?) -> String? {
		guard let jsonDateString = jsonDateString else { return nil }
		dateFormat = "yyyy-MM-dd"
		let date = self.date(from: jsonDateString.components(separatedBy: " ").first!)!
		dateFormat = "MMM d, yyyy"
		return string(from: date)
	}
	
	func jsonString(from englishDateString: String?) -> String? {
		guard let englishDateString = englishDateString else { return nil }
		dateFormat = "MMM d, yyyy"
		let date = self.date(from: englishDateString)!
		dateFormat = "yyyy-MM-dd"
		return string(from: date)
	}
}
