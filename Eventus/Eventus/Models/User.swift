import UIKit

class User {
	
	static let shared : User = {
		return User()
	}()
	
	var username: String? {
		didSet {
			UserDefaults.standard.set(username, forKey: "username")
			UserDefaults.standard.synchronize()
		}
	}
	
	var isLoggedIn: Bool? {
		didSet {
			UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
			UserDefaults.standard.synchronize()
		}
	}
	
	func populateDefaults() {
		username = UserDefaults.standard.value(forKey: "username") as? String
		isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool
	}
}
